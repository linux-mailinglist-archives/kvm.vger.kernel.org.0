Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A0848E570
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 09:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbiANISI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 03:18:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239560AbiANIR6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 03:17:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642148277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IUoonh6OYal9J1ZwVwpqRFVJ3/QYUBwJK8HyOa8FQ4E=;
        b=CWPHsbEBg1wnwrHqEdJ3P1aEIchskb8e+XpSfXpQDcpKW+oodfyhFXetUGuKFmZ/iJDg/O
        egCGSITMOz5XAwTXQlwexGjdUOUzI2Nq2Iks0U8bVyjshBMSYiX5wXzy+jNhz7UU2Mm785
        8QRWCzOu2u8JARYbz+pfntX/Dklzics=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-67uh35B1NU-AoczfBtTW_A-1; Fri, 14 Jan 2022 03:17:54 -0500
X-MC-Unique: 67uh35B1NU-AoczfBtTW_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED7B518C89DF;
        Fri, 14 Jan 2022 08:17:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3341E105914D;
        Fri, 14 Jan 2022 08:17:35 +0000 (UTC)
Message-ID: <4b9fb845bf698f7efa6b46d525b37e329dd693ea.camel@redhat.com>
Subject: Re: [PATCH v5 7/8] KVM: VMX: Update PID-pointer table entry when
 APIC ID is changed
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Chao Gao <chao.gao@intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Date:   Fri, 14 Jan 2022 10:17:34 +0200
In-Reply-To: <20220114025825.GA3010@gao-cwp>
References: <20211231142849.611-1-guang.zeng@intel.com>
         <20211231142849.611-8-guang.zeng@intel.com>
         <640e82f3-489d-60af-1d31-25096bef1a46@amd.com>
         <4eee5de5-ab76-7094-17aa-adc552032ba0@intel.com>
         <aa86022c-2816-4155-8d77-f4faf6018255@amd.com>
         <aa7db6d2-8463-2517-95ce-c0bba22e80d4@intel.com>
         <d058f7464084cadc183bd9dbf02c7f525bb9f902.camel@redhat.com>
         <20220110074523.GA18434@gao-cwp>
         <1ff69ed503faa4c5df3ad1b5abe8979d570ef2b8.camel@redhat.com>
         <YeClaZWM1cM+WLjH@google.com> <20220114025825.GA3010@gao-cwp>
Content-Type: multipart/mixed; boundary="=-gTfv472rn7j6C2YSy/9D"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-gTfv472rn7j6C2YSy/9D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2022-01-14 at 10:58 +0800, Chao Gao wrote:
> On Thu, Jan 13, 2022 at 10:19:21PM +0000, Sean Christopherson wrote:
> > On Tue, Jan 11, 2022, Maxim Levitsky wrote:
> > > Both Intel and AMD's PRM also state that changing APIC ID is implementation
> > > dependent.
> > >  
> > > I vote to forbid changing apic id, at least in the case any APIC acceleration
> > > is used, be that APICv or AVIC.
> > 
> > That has my vote as well.  For IPIv in particular there's not much concern with
> > backwards compability, i.e. we can tie the behavior to enable_ipiv.
Great!
> 
> Hi Sean and Levitsky,
> 
> Let's align on the implementation.
> 
> To disable changes for xAPIC ID when IPIv/AVIC is enabled:
> 
> 1. introduce a variable (forbid_apicid_change) for this behavior in kvm.ko
> and export it so that kvm-intel, kvm-amd can set it when IPIv/AVIC is
> enabled. To reduce complexity, this variable is a module level setting.
> 
> 2. when guest attempts to change xAPIC ID but it is forbidden, KVM prints
> a warning on host and injects a #GP to guest.
> 
> 3. remove AVIC code that deals with changes to xAPIC ID.
> 

I have a patch for both, I attached them.
I haven't tested either of these patches that much other than a smoke test,
but I did test all of the guests I  have and none broke in regard to boot.

I will send those patches as part of larger patch series that implements
nesting for AVIC. I hope to do this next week.

Best regards,
	Maxim Levitsky

--=-gTfv472rn7j6C2YSy/9D
Content-Disposition: attachment;
	filename*0=0001-KVM-x86-lapic-don-t-allow-to-change-APIC-ID-when-api.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-KVM-x86-lapic-don-t-allow-to-change-APIC-ID-when-api.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA0YTcwNDE2Yjk4YzQ3MjVkYzI4NjA4MTUyYjY2ZWM0MmEyMzNiMmU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogU3VuLCA5IEphbiAyMDIyIDE4OjA5OjA4ICswMjAwClN1YmplY3Q6IFtQQVRDSCAxLzhd
IEtWTTogeDg2OiBsYXBpYzogZG9uJ3QgYWxsb3cgdG8gY2hhbmdlIEFQSUMgSUQgd2hlbiBhcGlj
CiBhY2NlbGVyYXRpb24gaXMgZW5hYmxlZAoKTm8gc2FuZSBndWVzdCB3b3VsZCBjaGFuZ2UgcGh5
c2ljYWwgQVBJQyBJRHMsIGFuZCBhbGxvd2luZyB0aGlzIGludHJvZHVjZXMgYnVncwppbnRvIEFQ
SUMgYWNjZWxlcmF0aW9uIGNvZGUuCgpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBMZXZpdHNreSA8bWxl
dml0c2tAcmVkaGF0LmNvbT4KLS0tCiBhcmNoL3g4Ni9rdm0vbGFwaWMuYyB8IDEyICsrKysrKysr
Ky0tLQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jCmlu
ZGV4IDZlMWZiYmY0YzUwOGIuLjU2YmM0OTRjYWRkM2UgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2t2
bS9sYXBpYy5jCisrKyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jCkBAIC0yMDA3LDEwICsyMDA3LDE2
IEBAIGludCBrdm1fbGFwaWNfcmVnX3dyaXRlKHN0cnVjdCBrdm1fbGFwaWMgKmFwaWMsIHUzMiBy
ZWcsIHUzMiB2YWwpCiAKIAlzd2l0Y2ggKHJlZykgewogCWNhc2UgQVBJQ19JRDoJCS8qIExvY2Fs
IEFQSUMgSUQgKi8KLQkJaWYgKCFhcGljX3gyYXBpY19tb2RlKGFwaWMpKQotCQkJa3ZtX2FwaWNf
c2V0X3hhcGljX2lkKGFwaWMsIHZhbCA+PiAyNCk7Ci0JCWVsc2UKKwkJaWYgKCFhcGljX3gyYXBp
Y19tb2RlKGFwaWMpIHx8CisJCSAgICAvKgorCQkgICAgICogRG9uJ3QgYWxsb3cgc2V0dGluZyBB
UElDIElEIHdpdGggYW55IEFQSUMgYWNjZWxlcmF0aW9uCisJCSAgICAgKiBlbmFibGVkIHRvIGF2
b2lkIHVuZXhwZWN0ZWQgaXNzdWVzCisJCSAgICAgKi8KKwkJICAgIChlbmFibGVfYXBpY3YgJiYg
KCh2YWwgPj4gMjQpICE9IGFwaWMtPnZjcHUtPnZjcHVfaWQpKSkgewogCQkJcmV0ID0gMTsKKwkJ
CWJyZWFrOworCQl9CisJCWt2bV9hcGljX3NldF94YXBpY19pZChhcGljLCB2YWwgPj4gMjQpOwog
CQlicmVhazsKIAogCWNhc2UgQVBJQ19UQVNLUFJJOgotLSAKMi4yNi4zCgo=


--=-gTfv472rn7j6C2YSy/9D
Content-Disposition: attachment;
	filename*0=0002-KVM-x86-AVIC-remove-broken-code-that-updated-APIC-ID.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0002-KVM-x86-AVIC-remove-broken-code-that-updated-APIC-ID.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAzMjAwOTI0ZWQwNTZlZmU1OGIzZDFkMTI2NzVjMTk0YmVhOThjMGZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogU3VuLCA5IEphbiAyMDIyIDE4OjE0OjEyICswMjAwClN1YmplY3Q6IFtQQVRDSCAyLzhd
IEtWTTogeDg2OiBBVklDOiByZW1vdmUgYnJva2VuIGNvZGUgdGhhdCB1cGRhdGVkIEFQSUMgSUQK
ClNpZ25lZC1vZmYtYnk6IE1heGltIExldml0c2t5IDxtbGV2aXRza0ByZWRoYXQuY29tPgotLS0K
IGFyY2gveDg2L2t2bS9zdm0vYXZpYy5jIHwgMzcgKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3N2bS9hdmljLmMgYi9hcmNoL3g4Ni9rdm0v
c3ZtL2F2aWMuYwppbmRleCBmM2FiMDBmNDA3ZDViLi44NjU1YjM1MDQzMTM0IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9rdm0vc3ZtL2F2aWMuYworKysgYi9hcmNoL3g4Ni9rdm0vc3ZtL2F2aWMuYwpA
QCAtNDgwLDM1ICs0ODAsNiBAQCBzdGF0aWMgaW50IGF2aWNfaGFuZGxlX2xkcl91cGRhdGUoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1KQogCXJldHVybiByZXQ7CiB9CiAKLXN0YXRpYyBpbnQgYXZpY19o
YW5kbGVfYXBpY19pZF91cGRhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQotewotCXU2NCAqb2xk
LCAqbmV3OwotCXN0cnVjdCB2Y3B1X3N2bSAqc3ZtID0gdG9fc3ZtKHZjcHUpOwotCXUzMiBpZCA9
IGt2bV94YXBpY19pZCh2Y3B1LT5hcmNoLmFwaWMpOwotCi0JaWYgKHZjcHUtPnZjcHVfaWQgPT0g
aWQpCi0JCXJldHVybiAwOwotCi0Jb2xkID0gYXZpY19nZXRfcGh5c2ljYWxfaWRfZW50cnkodmNw
dSwgdmNwdS0+dmNwdV9pZCk7Ci0JbmV3ID0gYXZpY19nZXRfcGh5c2ljYWxfaWRfZW50cnkodmNw
dSwgaWQpOwotCWlmICghbmV3IHx8ICFvbGQpCi0JCXJldHVybiAxOwotCi0JLyogV2UgbmVlZCB0
byBtb3ZlIHBoeXNpY2FsX2lkX2VudHJ5IHRvIG5ldyBvZmZzZXQgKi8KLQkqbmV3ID0gKm9sZDsK
LQkqb2xkID0gMFVMTDsKLQl0b19zdm0odmNwdSktPmF2aWNfcGh5c2ljYWxfaWRfY2FjaGUgPSBu
ZXc7Ci0KLQkvKgotCSAqIEFsc28gdXBkYXRlIHRoZSBndWVzdCBwaHlzaWNhbCBBUElDIElEIGlu
IHRoZSBsb2dpY2FsCi0JICogQVBJQyBJRCB0YWJsZSBlbnRyeSBpZiBhbHJlYWR5IHNldHVwIHRo
ZSBMRFIuCi0JICovCi0JaWYgKHN2bS0+bGRyX3JlZykKLQkJYXZpY19oYW5kbGVfbGRyX3VwZGF0
ZSh2Y3B1KTsKLQotCXJldHVybiAwOwotfQotCiBzdGF0aWMgdm9pZCBhdmljX2hhbmRsZV9kZnJf
dXBkYXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKIAlzdHJ1Y3QgdmNwdV9zdm0gKnN2bSA9
IHRvX3N2bSh2Y3B1KTsKQEAgLTUyOSw4ICs1MDAsMTAgQEAgc3RhdGljIGludCBhdmljX3VuYWNj
ZWxfdHJhcF93cml0ZShzdHJ1Y3QgdmNwdV9zdm0gKnN2bSkKIAogCXN3aXRjaCAob2Zmc2V0KSB7
CiAJY2FzZSBBUElDX0lEOgotCQlpZiAoYXZpY19oYW5kbGVfYXBpY19pZF91cGRhdGUoJnN2bS0+
dmNwdSkpCi0JCQlyZXR1cm4gMDsKKwkJLyogcmVzdG9yZSB0aGUgdmFsdWUgdGhhdCB3ZSBoYWQs
IHdlIGRvbid0IHN1cHBvcnQgQVBJQyBJRAorCQkgKiBjaGFuZ2VzLCBidXQgZHVlIHRvIHRyYXAg
Vk0gZXhpdCwgdGhlIHZhbHVlIHdhcworCQkgKiBhbHJlYWR5IHdyaXR0ZW4qLworCQlrdm1fbGFw
aWNfcmVnX3dyaXRlKGFwaWMsIG9mZnNldCwgc3ZtLT52Y3B1LnZjcHVfaWQgPDwgMjQpOwogCQli
cmVhazsKIAljYXNlIEFQSUNfTERSOgogCQlpZiAoYXZpY19oYW5kbGVfbGRyX3VwZGF0ZSgmc3Zt
LT52Y3B1KSkKQEAgLTYyNCw4ICs1OTcsNiBAQCBpbnQgYXZpY19pbml0X3ZjcHUoc3RydWN0IHZj
cHVfc3ZtICpzdm0pCiAKIHZvaWQgYXZpY19wb3N0X3N0YXRlX3Jlc3RvcmUoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQogewotCWlmIChhdmljX2hhbmRsZV9hcGljX2lkX3VwZGF0ZSh2Y3B1KSAhPSAw
KQotCQlyZXR1cm47CiAJYXZpY19oYW5kbGVfZGZyX3VwZGF0ZSh2Y3B1KTsKIAlhdmljX2hhbmRs
ZV9sZHJfdXBkYXRlKHZjcHUpOwogfQotLSAKMi4yNi4zCgo=


--=-gTfv472rn7j6C2YSy/9D--

