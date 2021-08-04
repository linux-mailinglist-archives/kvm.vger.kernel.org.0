Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63C73E018A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238224AbhHDM7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:59:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52696 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238261AbhHDM7m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 08:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628081969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=X3G7MGVD9mP+lCtHaHeQsvnCvq/3cqemJsQF/MPjWbs=;
        b=dDJwlHMPwTHZt0b+Y4DoD02sE/iIzSmo/UHgi8lsCvwpMmePsxmGjcCNJu5CCth1CI9p+X
        NbyFYCfaSo33mp4GvLDlcahgfZDZR6GD7cHnRK1aNE6C5upk8Rb6h1gSlY7yYYQH+resjI
        QL8+xeI5yMs/Pa/OIKysf7P5HwsnLas=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-4wm9UeMiN4qwsqNCBiRDDA-1; Wed, 04 Aug 2021 08:59:27 -0400
X-MC-Unique: 4wm9UeMiN4qwsqNCBiRDDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6989107ACF5;
        Wed,  4 Aug 2021 12:59:26 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26C22E2C3;
        Wed,  4 Aug 2021 12:59:17 +0000 (UTC)
Message-ID: <f8071f73869de34961ea1a35177fc778bb99d4b7.camel@redhat.com>
Subject: Possible minor CPU bug on Zen2 in regard to using very high GPA in
 a VM
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Gilbert <dgilbert@redhat.com>,
        David Matlack <dmatlack@google.com>
Date:   Wed, 04 Aug 2021 15:59:16 +0300
Content-Type: multipart/mixed; boundary="=-BQsp4b3YOnp9b/1yp7Ka"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-BQsp4b3YOnp9b/1yp7Ka
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi!
 
I recently triaged a series of failures that I am seeing on both of my AMD machines in the kvm selftests.

One test failed due to a trivial typo, to which I had sent a fix, but most of the other tests failed
due to what I now suspect to be a very minor but still a CPU bug.
 
All of the failing tests except two tests that timeout (and I haven't yet triaged them),
use the perf_test_util.c library.
All of these fail with SHUTDOWN exit reason.

After a relatively recent commit ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()"),
vm_get_max_gfn() was fixed to return the maximum GFN that the guest can use.
For default VM type this value is obtained from 'vm->pa_bit's which is in turn obtained
from guest's cpuid in kvm_get_cpu_address_width function.
 
It is 48 on both my AMD machines (3970X and 4650U) and also on remote EPYC 7302P machine.
(all of them are Zen2 machines)
 
My 3970X has SME enabled by BIOS, while my 4650U doesn't have it enabled.
The 7302P also has SME enabled.
SEV was obviously not enabled for the test.
NPT was enabled.
 
It appears that if the guest uses any GPA above 0xFFFCFFFFF000 in its guest paging tables, 
then it gets #PF with reserved bits error code.
 
That causes the guest to shutdown because the kvm unit tests don't setup exception handling
(I think).
 
I used my 'intercept all exceptions' debug feature to enable #PF intercept which allowed
me to clearly see the #PF with a reserved bit reason happening prior to shutdown.
 
I attached a simple reproducer for this.
 

PS:
 
I did my best to check that this isn't a code/compiler bug in the selftests.
 
I did find one bug (which one can even claim to be a compiler bug,
but I think that due to very undefined nature of bitfields, the compiler
is allowed to do this):
 
In addr_gva2gpa we have this code 
 
return (pte[index[0]].pfn * vm->page_size) + (gva & 0xfffu);
 
The pfn is declared as 'uint64_t pfn:40'
 
When the PTE is set to 'fffd00000003' for example,
this code for some reason returns 0xfd00000000 instead of '0xfffd00000000'
 
If 'pte[index[0]].pfn' is copied to uint64_t variable and then 
shifted / multiplied by the page size then the correct value is printed.
 
This was tested on both gcc 10.2.1 that comes with fedora 32,  gcc 11.1.1 that 
comes with fedora 34 and gcc 8.5.0 that comes with RHEL 8.5.0.
 
However the raw PTE value does seem to be correctly set, so it looks like
this problem is not related to the possible CPU bug I found.
 
The reproducer I attached has few test 'printf's for this issue as well.
 
Best regards,
	Maxim Levitsky




--=-BQsp4b3YOnp9b/1yp7Ka
Content-Disposition: attachment; filename="0001-KVM-selftests-add-large-GPA-reproducer.patch"
Content-Type: text/x-patch; name="0001-KVM-selftests-add-large-GPA-reproducer.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA4YTVhYzBiNzExYWMwNjI4OTdjMTZiOTI4OTk4OTk2OWNiNjZlNWU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogV2VkLCA0IEF1ZyAyMDIxIDEyOjQwOjAzICswMzAwClN1YmplY3Q6IFtQQVRDSF0gS1ZN
OiBzZWxmdGVzdHM6IGFkZCBsYXJnZSBHUEEgcmVwcm9kdWNlcgoKLS0tCiB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9rdm0vLmdpdGlnbm9yZSAgICAgICAgfCAgMSArCiB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9rdm0vTWFrZWZpbGUgICAgICAgICAgfCAgMSArCiAuLi4vc2VsZnRlc3RzL2t2bS9s
aWIveDg2XzY0L3Byb2Nlc3Nvci5jICAgICAgfCAgOCArKysKIC4uLi9zZWxmdGVzdHMva3ZtL3g4
Nl82NC9sYXJnZV9ncGFfdGVzdC5jICAgICB8IDU2ICsrKysrKysrKysrKysrKysrKysKIDQgZmls
ZXMgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKQogY3JlYXRlIG1vZGUgMTAwNjQ0IHRvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2t2bS94ODZfNjQvbGFyZ2VfZ3BhX3Rlc3QuYwoKZGlmZiAtLWdpdCBh
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS8uZ2l0aWdub3JlIGIvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMva3ZtLy5naXRpZ25vcmUKaW5kZXggMzY4OTZkMjUxOTc3Li5iODlmYzk4ODZiNTQg
MTAwNjQ0Ci0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS8uZ2l0aWdub3JlCisrKyBi
L3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS8uZ2l0aWdub3JlCkBAIC0zOSw2ICszOSw3IEBA
CiAveDg2XzY0L3hzc19tc3JfdGVzdAogL3g4Nl82NC92bXhfcG11X21zcnNfdGVzdAogL3g4Nl82
NC92bXhfcGlfbW1pb190ZXN0CisveDg2XzY0L2xhcmdlX2dwYV90ZXN0cwogL2FjY2Vzc190cmFj
a2luZ19wZXJmX3Rlc3QKIC9kZW1hbmRfcGFnaW5nX3Rlc3QKIC9kaXJ0eV9sb2dfdGVzdApkaWZm
IC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlIGIvdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCmluZGV4IGMxMDM4NzM1MzFlMC4uNmMxZmYyNTk0
NjA3IDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vTWFrZWZpbGUKKysr
IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL01ha2VmaWxlCkBAIC04NCw2ICs4NCw3IEBA
IFRFU1RfR0VOX1BST0dTX3g4Nl82NCArPSBtZW1zbG90X3BlcmZfdGVzdAogVEVTVF9HRU5fUFJP
R1NfeDg2XzY0ICs9IHNldF9tZW1vcnlfcmVnaW9uX3Rlc3QKIFRFU1RfR0VOX1BST0dTX3g4Nl82
NCArPSBzdGVhbF90aW1lCiBURVNUX0dFTl9QUk9HU194ODZfNjQgKz0ga3ZtX2JpbmFyeV9zdGF0
c190ZXN0CitURVNUX0dFTl9QUk9HU194ODZfNjQgKz0geDg2XzY0L2xhcmdlX2dwYV90ZXN0CiAK
IFRFU1RfR0VOX1BST0dTX2FhcmNoNjQgKz0gYWFyY2g2NC9kZWJ1Zy1leGNlcHRpb25zCiBURVNU
X0dFTl9QUk9HU19hYXJjaDY0ICs9IGFhcmNoNjQvZ2V0LXJlZy1saXN0CmRpZmYgLS1naXQgYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vbGliL3g4Nl82NC9wcm9jZXNzb3IuYyBiL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9saWIveDg2XzY0L3Byb2Nlc3Nvci5jCmluZGV4IDI4Y2I4
ODFmNDQwZC4uYjU2NDI5OGI5YjRkIDEwMDY0NAotLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0vbGliL3g4Nl82NC9wcm9jZXNzb3IuYworKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9rdm0vbGliL3g4Nl82NC9wcm9jZXNzb3IuYwpAQCAtNTg3LDYgKzU4NywxNCBAQCB2bV9wYWRk
cl90IGFkZHJfZ3ZhMmdwYShzdHJ1Y3Qga3ZtX3ZtICp2bSwgdm1fdmFkZHJfdCBndmEpCiAJaWYg
KCFwdGVbaW5kZXhbMF1dLnByZXNlbnQpCiAJCWdvdG8gdW5tYXBwZWRfZ3ZhOwogCisJdWludDY0
X3QgcmF3X3ZhbHVlID0gKih1aW50NjRfdCopJnB0ZVtpbmRleFswXV07CisJdWludDY0X3QgcGZu
ID0gcHRlW2luZGV4WzBdXS5wZm47CisKKwlwcmludGYoIlJhdyBQVEUgdmFsdWUgaXMgJWx4XG4i
LCByYXdfdmFsdWUpOworCXByaW50ZigiUmF3IFBGTiB2YWx1ZSBpcyAlbHhcbiIsIHBmbik7CisJ
cHJpbnRmKCJSYXcgUEZOIHNoaWZ0ZWQgYnkgMTIgYml0IHZhbHVlIGlzICVseFxuIiwgcGZuIDw8
IDEyVUxMKTsKKwlwcmludGYoIlJhdyBQRk4gc2hpZnRlZCBieSAxMiBiaXQgdmFsdWUgaXMgJWx4
XG4iLCAocHRlW2luZGV4WzBdXS5wZm4pIDw8IDEyVUxMKTsKKwogCXJldHVybiAocHRlW2luZGV4
WzBdXS5wZm4gKiB2bS0+cGFnZV9zaXplKSArIChndmEgJiAweGZmZnUpOwogCiB1bm1hcHBlZF9n
dmE6CmRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L2xhcmdl
X2dwYV90ZXN0LmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2XzY0L2xhcmdlX2dw
YV90ZXN0LmMKbmV3IGZpbGUgbW9kZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi5jMGVmOTQ1
MGU4ODUKLS0tIC9kZXYvbnVsbAorKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0veDg2
XzY0L2xhcmdlX2dwYV90ZXN0LmMKQEAgLTAsMCArMSw1NiBAQAorLy8gU1BEWC1MaWNlbnNlLUlk
ZW50aWZpZXI6IEdQTC0yLjAtb25seQorLyoKKyAqIENvcHlyaWdodCAoQykgMjAyMSwgUmVkIEhh
dCwgSW5jLgorICovCisjaW5jbHVkZSAidGVzdF91dGlsLmgiCisjaW5jbHVkZSAia3ZtX3V0aWwu
aCIKKyNpbmNsdWRlICJwcm9jZXNzb3IuaCIKKworI2RlZmluZSBWQ1BVX0lEIDAKKyNkZWZpbmUg
RVhUUkFfU0xPVF9JTkRFWCAxCisjZGVmaW5lIEVYVFJBX1NMT1RfTlVNUEFHRVMgMQorCisvLyNk
ZWZpbmUgRVhUUkFfU0xPVF9HUEEgMHgwMDAwRkZGRkZGRkZGMDAwIC8vIGZhaWxzCisvLyNkZWZp
bmUgRVhUUkFfU0xPVF9HUEEgMHgwMDAwRkZGREZGRkZGMDAwIC8vIGZhaWxzCisjZGVmaW5lIEVY
VFJBX1NMT1RfR1BBICAgMHgwMDAwRkZGRDAwMDAwMDAwIC8vIGZhaWxzCisvLyNkZWZpbmUgRVhU
UkFfU0xPVF9HUEEgMHgwMDAwRkZGQ0ZGRkZGMDAwIC8vIHdvcmtzCisvLyNkZWZpbmUgRVhUUkFf
U0xPVF9HUEEgMHgwMDAwRkZGQkZGRkZGMDAwIC8vIHdvcmtzCisKKyNkZWZpbmUgTUFQX0dWQSAw
eDgwMDAwMDAwIC8vIGRvZXNuJ3Qgc2VlbSB0byBtYXR0ZXIKKworc3RhdGljIHZvaWQgZ3Vlc3Rf
bWFpbih2b2lkKQoreworCXZvbGF0aWxlIHVpbnQzMl90KiBwdHIgPSAodWludDMyX3QqIClNQVBf
R1ZBOworCSpwdHIgPSAweEMwRkZFRTsKKwlHVUVTVF9ET05FKCk7Cit9CisKK2ludCBtYWluKHZv
aWQpCit7CisJc3RydWN0IGt2bV92bSAqdm07CisJc3RydWN0IGt2bV9ydW4gKnJ1bjsKKwl1aW50
NjRfdCByZXN1bHRfZ3BhOworCisJdm0gPSB2bV9jcmVhdGVfZGVmYXVsdChWQ1BVX0lELCAwLCBn
dWVzdF9tYWluKTsKKwlydW4gPSB2Y3B1X3N0YXRlKHZtLCBWQ1BVX0lEKTsKKworCXZtX3VzZXJz
cGFjZV9tZW1fcmVnaW9uX2FkZCh2bSwgVk1fTUVNX1NSQ19BTk9OWU1PVVMsCisJCQkJCUVYVFJB
X1NMT1RfR1BBLAorCQkJCQlFWFRSQV9TTE9UX0lOREVYLAorCQkJCQlFWFRSQV9TTE9UX05VTVBB
R0VTLCAwKTsKKworCXZpcnRfbWFwKHZtLCBNQVBfR1ZBLCBFWFRSQV9TTE9UX0dQQSwgRVhUUkFf
U0xPVF9OVU1QQUdFUyk7CisKKwlyZXN1bHRfZ3BhID0gYWRkcl9ndmEyZ3BhKHZtLCBNQVBfR1ZB
KTsKKworCXByaW50ZigibWFwcGVkIEdQQSBpcyAweCVseFxuIiwgcmVzdWx0X2dwYSk7CisKKwlf
dmNwdV9ydW4odm0sIFZDUFVfSUQpOworCisJVEVTVF9BU1NFUlQocnVuLT5leGl0X3JlYXNvbiA9
PSBLVk1fRVhJVF9JTywKKwkJICAgICJ1bmV4cGVjdGVkIGV4aXQgcmVhc29uOiAldSAoJXMpLFxu
IiwKKwkJICAgIHJ1bi0+ZXhpdF9yZWFzb24sCisJCSAgICBleGl0X3JlYXNvbl9zdHIocnVuLT5l
eGl0X3JlYXNvbikpOworCisJa3ZtX3ZtX2ZyZWUodm0pOworfQotLSAKMi4yNi4zCgo=


--=-BQsp4b3YOnp9b/1yp7Ka--

