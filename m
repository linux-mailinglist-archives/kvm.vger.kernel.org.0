Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394E1465AA1
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 01:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344324AbhLBAYf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 19:24:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354247AbhLBAY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Dec 2021 19:24:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638404467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhjUm+Uzq07hcdbPpfZp7q3IwjENAUM81hW4GGc1zR4=;
        b=FUV00i55fhct8klXl6aNyO1De3i9BtHNor0WdEM/dEEtuNhpicX8hU5jIHEukgZjL6NiiB
        NB+vsW1GGai++Lh3HNCs0/KOvD5dG+v/ZOd8up3XaEQ+EVFhw+FNH0vAPQ9Q7wMLi0IR9S
        5lZqcefHOdmBT3Bv9+ycAl+GOZrPUfM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-469-7M16yyPZNkOCqvz9ClWIdA-1; Wed, 01 Dec 2021 19:21:04 -0500
X-MC-Unique: 7M16yyPZNkOCqvz9ClWIdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EC65102CC41;
        Thu,  2 Dec 2021 00:21:00 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBF425D6BA;
        Thu,  2 Dec 2021 00:20:46 +0000 (UTC)
Message-ID: <32eabe7d270e5a466ba2d9345b4270b8fe27700c.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Wei Huang <wei.huang2@amd.com>
Date:   Thu, 02 Dec 2021 02:20:45 +0200
In-Reply-To: <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-12-seanjc@google.com>
         <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
         <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
         <YaUNBfJh35WXMV0M@google.com>
         <496c2fc6-26b0-9b5d-32f4-2f9e9dd6a064@redhat.com>
         <YaUiEquKYi5eqWC0@google.com>
         <880a5727-69d1-72a1-b129-b053781625ad@redhat.com>
         <458c0819a578ba854f00089bc312c8faa177a81a.camel@redhat.com>
Content-Type: multipart/mixed; boundary="=-XBtBz6EzfH3Aw3rcptLe"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-XBtBz6EzfH3Aw3rcptLe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2021-11-30 at 00:53 +0200, Maxim Levitsky wrote:
> On Mon, 2021-11-29 at 20:18 +0100, Paolo Bonzini wrote:
> > On 11/29/21 19:55, Sean Christopherson wrote:
> > > > Still it does seem to be a race that happens when IS_RUNNING=true but
> > > > vcpu->mode == OUTSIDE_GUEST_MODE.  This patch makes the race easier to
> > > > trigger because it moves IS_RUNNING=false later.
> > > 
> > > Oh!  Any chance the bug only repros with preemption enabled?  That would explain
> > > why I don't see problems, I'm pretty sure I've only run AVIC with a PREEMPT=n.
> > 
> > Me too.
> > 
> > > svm_vcpu_{un}blocking() are called with preemption enabled, and avic_set_running()
> > > passes in vcpu->cpu.  If the vCPU is preempted and scheduled in on a different CPU,
> > > avic_vcpu_load() will overwrite the vCPU's entry with the wrong CPU info.
> > 
> > That would make a lot of sense.  avic_vcpu_load() can handle 
> > svm->avic_is_running = false, but avic_set_running still needs its body 
> > wrapped by preempt_disable/preempt_enable.
> > 
> > Fedora's kernel is CONFIG_PREEMPT_VOLUNTARY, but I know Maxim uses his 
> > own build so it would not surprise me if he used CONFIG_PREEMPT=y.
> > 
> > Paolo
> > 
> 
> I will write ll the details tomorrow but I strongly suspect the CPU errata 
> https://developer.amd.com/wp-content/resources/56323-PUB_0.78.pdf
> #1235
>  
> Basically what I see that
>  
> 1. vCPU2 disables is_running in avic physical id cache
> 2. vCPU2 checks that IRR is empty and it is
> 3. vCPU2 does schedule();
>  
> and it keeps on sleeping forever. If I kick it via signal 
> (like just doing 'info registers' qemu hmp command
> or just stop/cont on the same hmp interface, the
> vCPU wakes up and notices that IRR suddenly is not empty,
> and the VM comes back to life (and then hangs after a while again
> with the same problem....).
>  
> As far as I see in the traces, the bit in IRR came from
> another VCPU who didn't respect the ir_running bit and didn't get 
> AVIC_INCOMPLETE_IPI VMexit.
> I can't 100% prove it yet, but everything in the trace shows this.
>  
> About the rest of the environment, currently I reproduce this in
> a VM which has no pci passed through devices at all, just AVIC.
> (I wasn't able to reproduce it before just because I forgot to
> enable AVIC in this configuration).
>  
> So I also agree that Sean's patch is not to blame here,
> it just made the window between setting is_running and getting to sleep
> shorter and made it less likely that other vCPUs will pick up the is_running change.
> (I suspect that they pick it up on next vmrun, and otherwise the value is somehow
> cached wrongfully in them).
>  
> A very performance killing workaround of kicking all vCPUs when one of them enters vcpu_block
> does seem to work for me but it skews all the timing off so I can't prove it.
>  
> That is all, I will write more detailed info, including some traces I have.
>  
> I do use windows 10 with so called LatencyMon in it, which shows overall how
> much latency hardware interrupts have, which used to be useful for me to
> ensure that my VMs are suitable for RT like latency (even before I joined RedHat,
> I tuned my VMs as much as I could to make my Rift CV1 VR headset work well which 
> needs RT like latencies.
>  
> These days VR works fine in my VMs anyway, but I still kept this tool to keep an eye on it).
>  
> I really need to write a kvm unit test to stress test IPIs, especially this case,
> I will do this very soon.
>  
>  
> Wei Huang, any info on this would be very helpful. 
>  
> Maybe putting the avic physical table in UC memory would help? 
> Maybe ringing doorbells of all other vcpus will help them notice the change?
> 
> Best regards,
> 	Maxim Levitsky


Hi!

I am now almost sure that this is errata #1235.

I had attached a kvm-unit-test I wrote (patch against master of https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git/)
which is able to reproduce the issue on stock 5.15.0 kernel (*no patches applied at all*) after just few seconds.
If kvm is loaded without halt-polling (that is  halt_poll_ns=0 is used).

Halt polling and/or Sean's patch are not to blame, it just changes timeing.
With Sean's patch I don't need to disable half polling.

I did find few avic inhibition bugs that this test also finds and to make it work before I fix them,
I added a workaround to not hit them in this test.
I'll send patches to fix those very soon.
Note that in windows VM there were no avic inhibitions so those bugs are not relevant.

Wei Huang, do you know if this issue is fixed on Zen3, and if it is fixed on some Zen2 machines?
Any workarounds other than 'don't use avic'?

Best regards,
	Maxim Levitsky


--=-XBtBz6EzfH3Aw3rcptLe
Content-Disposition: attachment; filename="0001-add-unit-test-for-avic-ipi.patch"
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; name="0001-add-unit-test-for-avic-ipi.patch";
	charset="UTF-8"

RnJvbSBkYmEyOTU1NzlkMTBmZjg4YjU5NjY5N2M4NjFhN2M4M2Y1ZTlkMDEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXhpbSBMZXZpdHNreSA8bWxldml0c2tAcmVkaGF0LmNvbT4K
RGF0ZTogVHVlLCAzMCBOb3YgMjAyMSAxMzo1Njo1NyArMDIwMApTdWJqZWN0OiBbUEFUQ0hdIGFk
ZCB1bml0IHRlc3QgZm9yIGF2aWMgaXBpCgpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBMZXZpdHNreSA8
bWxldml0c2tAcmVkaGF0LmNvbT4KLS0tCiB4ODYvTWFrZWZpbGUuY29tbW9uIHwgICAzICstCiB4
ODYvaXBpX3N0cmVzcy5jICAgIHwgMTY5ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrCiB4ODYvdW5pdHRlc3RzLmNmZyAgIHwgICA1ICsrCiAzIGZpbGVzIGNoYW5n
ZWQsIDE3NiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQg
eDg2L2lwaV9zdHJlc3MuYwoKZGlmZiAtLWdpdCBhL3g4Ni9NYWtlZmlsZS5jb21tb24gYi94ODYv
TWFrZWZpbGUuY29tbW9uCmluZGV4IDQ2MWRlNTEuLjM3MmQ2ZWMgMTAwNjQ0Ci0tLSBhL3g4Ni9N
YWtlZmlsZS5jb21tb24KKysrIGIveDg2L01ha2VmaWxlLmNvbW1vbgpAQCAtNjAsNyArNjAsOCBA
QCB0ZXN0cy1jb21tb24gPSAkKFRFU1RfRElSKS92bWV4aXQuZmxhdCAkKFRFU1RfRElSKS90c2Mu
ZmxhdCBcCiAgICAgICAgICAgICAgICAkKFRFU1RfRElSKS9pbml0LmZsYXQgJChURVNUX0RJUikv
c21hcC5mbGF0IFwKICAgICAgICAgICAgICAgICQoVEVTVF9ESVIpL2h5cGVydl9zeW5pYy5mbGF0
ICQoVEVTVF9ESVIpL2h5cGVydl9zdGltZXIuZmxhdCBcCiAgICAgICAgICAgICAgICAkKFRFU1Rf
RElSKS9oeXBlcnZfY29ubmVjdGlvbnMuZmxhdCBcCi0gICAgICAgICAgICAgICAkKFRFU1RfRElS
KS91bWlwLmZsYXQgJChURVNUX0RJUikvdHN4LWN0cmwuZmxhdAorICAgICAgICAgICAgICAgJChU
RVNUX0RJUikvdW1pcC5mbGF0ICQoVEVTVF9ESVIpL3RzeC1jdHJsLmZsYXQgXAorICAgICAgICAg
ICAgICAgJChURVNUX0RJUikvaXBpX3N0cmVzcy5mbGF0CiAKIHRlc3RfY2FzZXM6ICQodGVzdHMt
Y29tbW9uKSAkKHRlc3RzKQogCmRpZmYgLS1naXQgYS94ODYvaXBpX3N0cmVzcy5jIGIveDg2L2lw
aV9zdHJlc3MuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi41MGNiZjM5Ci0t
LSAvZGV2L251bGwKKysrIGIveDg2L2lwaV9zdHJlc3MuYwpAQCAtMCwwICsxLDE2OSBAQAorI2lu
Y2x1ZGUgImxpYmNmbGF0LmgiCisjaW5jbHVkZSAic21wLmgiCisjaW5jbHVkZSAiYWxsb2MuaCIK
KyNpbmNsdWRlICJhcGljLmgiCisjaW5jbHVkZSAicHJvY2Vzc29yLmgiCisjaW5jbHVkZSAiaXNy
LmgiCisjaW5jbHVkZSAiYXNtL2JhcnJpZXIuaCIKKyNpbmNsdWRlICJkZWxheS5oIgorI2luY2x1
ZGUgImF0b21pYy5oIgorCitzdGF0aWMgYXRvbWljX3QgcnVubmluZ19jcHVzOworCit2b2xhdGls
ZSB1NjQgKmlzcl9jb3VudHM7CisKK3ZvbGF0aWxlIGJvb2wgZmluaXNoX2luaXQ7CisKK3U2NCBu
dW1fb3V0ZXJfaXRlcmF0aW9ucyA9IDU7CisjZGVmaW5lIE5VTV9JTk5FUl9JVEVSQVRJT05TIDEw
MDAwCisjZGVmaW5lIFRPVEFMX05VTUJFUl9JVEVSQVRJT05TIChudW1fb3V0ZXJfaXRlcmF0aW9u
cyAqIE5VTV9JTk5FUl9JVEVSQVRJT05TKQorCitzdGF0aWMgdm9pZCBpcGlfaW50ZXJydXB0X2hh
bmRsZXIoaXNyX3JlZ3NfdCAqcikKK3sKKwlpc3JfY291bnRzW3NtcF9pZCgpXSsrOworCWVvaSgp
OworfQorCitzdGF0aWMgIHZvaWQgd2FpdF9mb3JfaXBpKHZvbGF0aWxlIHU2NCAqY291bnQpCit7
CisJdTY0IG9sZF9jb3VudCA9ICpjb3VudDsKKwl3aGlsZSAoMSkgeworCQlpZiAoKHJkdHNjKCkg
Pj4gNCkgJSAxMDAwMCAhPSAwICkgeworCQkJYXNtIHZvbGF0aWxlKAorCQkJICAgIC8qIHNob3J0
IHdpbmRvdyBmb3IgaW50ZXJydXB0cyAqLworCQkJICAgICJzdGlcbiIKKwkJCSAgICAibm9wXG4i
CisJCQkgICAgImNsaVxuIgorCQkJKTsKKwkJCWlmIChvbGRfY291bnQgIT0gKmNvdW50KQorCQkJ
CWJyZWFrOworCQl9CisKKwkJZWxzZSB7CisJCQlhc20gdm9sYXRpbGUoCisJCQkgICAgLyogc2hv
cnQgd2luZG93IGZvciBpbnRlcnJ1cHRzICovCisJCQkgICAgInN0aVxuIgorCQkJICAgICJobHRc
biIKKwkJCSAgICAiY2xpXG4iCisJCQkpOworCisJCQlpZiAob2xkX2NvdW50ICE9ICpjb3VudCkK
KwkJCQlicmVhazsKKwkJfQorCX07Cit9CisKK3N0YXRpYyB2b2lkIHZjcHVfaW5pdCh2b2lkICpk
YXRhKQoreworCWludCBjcHUgPSAobG9uZylkYXRhOworCisJLyogVG8gbWFrZSBpdCBlYXNpZXIg
dG8gc2VlIGl0ZXJhdGlvbiBudW1iZXIgaW4gdGhlIHRyYWNlICovCisJaGFuZGxlX2lycSgweDQw
LCBpcGlfaW50ZXJydXB0X2hhbmRsZXIpOworCWhhbmRsZV9pcnEoMHg1MCwgaXBpX2ludGVycnVw
dF9oYW5kbGVyKTsKKworCWF0b21pY19pbmMoJnJ1bm5pbmdfY3B1cyk7CisKKwlpZiAoY3B1ICE9
IDApCisJCXdoaWxlICghZmluaXNoX2luaXQpOworfQorCitzdGF0aWMgdm9pZCB2Y3B1X2NvZGUo
dm9pZCAqZGF0YSkKK3sKKwlpbnQgbmNwdXMgPSBjcHVfY291bnQoKTsKKwlpbnQgY3B1ID0gKGxv
bmcpZGF0YTsKKwl1NjQgaTsKKworCWFzc2VydChjcHUgIT0gMCk7CisJaWYgKGNwdSAhPSAxKQor
CQl3YWl0X2Zvcl9pcGkoJmlzcl9jb3VudHNbY3B1XSk7CisKKwlmb3IgKGkgPSAwOyBpIDwgVE9U
QUxfTlVNQkVSX0lURVJBVElPTlM7IGkrKykgeworCisJCXU4IHBoeXNpY2FsX2RzdCA9IGNwdSA9
PSBuY3B1cyAtMSA/IDEgOiBjcHUgKyAxOworCisJCS8vIHNlbmQgSVBJIHRvIGEgbmV4dCB2Q1BV
IGluIGEgY2lyY3VsYXIgZmFzaGlvbgorCQlhcGljX2ljcl93cml0ZShBUElDX0lOVF9BU1NFUlQg
fAorCQkJCUFQSUNfREVTVF9QSFlTSUNBTCB8CisJCQkJQVBJQ19ETV9GSVhFRCB8CisJCQkJKGkg
JSAyID8gMHg0MCA6IDB4NTApLAorCQkJCXBoeXNpY2FsX2RzdCk7CisKKwkJLy8gd2FpdCBmb3Ig
dGhlIElQSSBpbnRlcnJ1cHQgY2hhaW4gdG8gY29tZSBiYWNrIHRvIHVzCisJCWlmIChpIDwgKFRP
VEFMX05VTUJFUl9JVEVSQVRJT05TIC0gMSkgfHwgY3B1ID09IDEpCisJCQl3YWl0X2Zvcl9pcGko
Jmlzcl9jb3VudHNbY3B1XSk7CisKKwkJaWYgKGNwdSA9PSAxICYmIChpICUgTlVNX0lOTkVSX0lU
RVJBVElPTlMgPT0gMCkpCisJCQlwcmludGYoIi4iKTsKKwl9Cit9CisKKworCitpbnQgbWFpbihp
bnQgYXJnYywgdm9pZCoqIGFyZ3YpCit7CisJaW50IGNwdSwgbmNwdXMgPSBjcHVfY291bnQoKTsK
KworCWFzc2VydChuY3B1cyA+IDIpOworCisJaWYgKGFyZ2MgPiAxKQorCQludW1fb3V0ZXJfaXRl
cmF0aW9ucyA9IGF0b2woYXJndlsxXSk7CisKKwlpc3JfY291bnRzID0gKHZvbGF0aWxlIHU2NCAq
KWNhbGxvYyhuY3B1cywgc2l6ZW9mKHU2NCkpOworCisJcHJpbnRmKCJmb3VuZCAlZCBjcHVzXG4i
LCBuY3B1cyk7CisJcHJpbnRmKCJydW5uaW5nIGZvciAlbGxkIGl0ZXJhdGlvbnNcbiIsCisJCShs
b25nIGxvbmcgdW5zaWduZWQgaW50KVRPVEFMX05VTUJFUl9JVEVSQVRJT05TKTsKKworCS8qCisJ
ICogRW5zdXJlIHRoYXQgd2UgZG9uJ3QgaGF2ZSBpbnRlcnJ1cHQgd2luZG93IHBlbmRpbmcKKwkg
KiBmcm9tIFBJVCB0aW1lciB3aGljaCBpbmhpYml0cyB0aGUgQVZJQy4KKwkgKi8KKworCWZvciAo
Y3B1ID0gMDsgY3B1IDwgbmNwdXM7ICsrY3B1KQorCQlvbl9jcHVfYXN5bmMoY3B1LCB2Y3B1X2lu
aXQsICh2b2lkICopKGxvbmcpY3B1KTsKKworCS8qIFdvcmthcm91bmQgZm9yIGFwaWMtPmlycl9w
ZW5kaW5nIGJ1ZyB2cyBhdmljIGluaGliaXR0aW9uOgorCSAqIEVuc3VyZSB0aGF0IGFsbCB2Q1BV
cyBhcmUgcnVubmluZyBiZWZvcmUgdW5pbmhpYml0aW5nIHRoZSBBVklDCisJICogKi8KKworCXdo
aWxlIChhdG9taWNfcmVhZCgmcnVubmluZ19jcHVzKSA8IG5jcHVzKQorCQlwYXVzZSgpOworCisJ
YXNtIHZvbGF0aWxlKCJzdGk7bm9wO2NsaVxuIik7CisKKwkvKiBub3cgbGV0IGFsbCB0aGUgdkNQ
VXMgZW5kIHRoZSBJUEkgZnVuY3Rpb24qLworCWZpbmlzaF9pbml0ID0gdHJ1ZTsKKworCXdoaWxl
IChjcHVzX2FjdGl2ZSgpID4gMSkKKwkgICAgICBwYXVzZSgpOworCisJcHJpbnRmKCJzdGFydGlu
ZyB0ZXN0IG9uIGFsbCBjcHVzIGJ1dCAwLi4uXG4iKTsKKworCWZvciAoY3B1ID0gbmNwdXMtMTsg
Y3B1ID4gMDsgY3B1LS0pCisJCW9uX2NwdV9hc3luYyhjcHUsIHZjcHVfY29kZSwgKHZvaWQgKiko
bG9uZyljcHUpOworCisJcHJpbnRmKCJ0ZXN0IHN0YXJ0ZWQsIHdhaXRpbmcgdG8gZW5kLi4uXG4i
KTsKKworCXdoaWxlIChjcHVzX2FjdGl2ZSgpID4gMSkgeworCisJCXU2NCBpc3JfY291bnQxID0g
aXNyX2NvdW50c1sxXTsKKworCQlkZWxheSg1VUxMKjEwMDAqMTAwMCoxMDAwKTsKKworCQlpZiAo
aXNyX2NvdW50MSA9PSBpc3JfY291bnRzWzFdKSB7CisJCQlwcmludGYoIlxuIik7CisJCQlwcmlu
dGYoImhhbmcgZGV0ZWN0ZWQhIVxuIik7CisJCQlicmVhazsKKwkJfQorCX0KKworCXByaW50Zigi
XG4iKTsKKworCWZvciAoY3B1ID0gMTsgY3B1IDwgbmNwdXM7ICsrY3B1KQorCQlyZXBvcnQoaXNy
X2NvdW50c1tjcHVdID09IFRPVEFMX05VTUJFUl9JVEVSQVRJT05TLAorCQkJCSJOdW1iZXIgb2Yg
SVBJcyBtYXRjaCAoJWxsZCkiLAorCQkJCShsb25nIGxvbmcgdW5zaWduZWQgaW50KWlzcl9jb3Vu
dHNbY3B1XSk7CisKKwlmcmVlKCh2b2lkKilpc3JfY291bnRzKTsKKwlyZXR1cm4gcmVwb3J0X3N1
bW1hcnkoKTsKK30KZGlmZiAtLWdpdCBhL3g4Ni91bml0dGVzdHMuY2ZnIGIveDg2L3VuaXR0ZXN0
cy5jZmcKaW5kZXggNjI0NDU5NS4uZmY4NjZiNCAxMDA2NDQKLS0tIGEveDg2L3VuaXR0ZXN0cy5j
ZmcKKysrIGIveDg2L3VuaXR0ZXN0cy5jZmcKQEAgLTYxLDYgKzYxLDExIEBAIHNtcCA9IDIKIGZp
bGUgPSBzbXB0ZXN0LmZsYXQKIHNtcCA9IDMKIAorW2lwaV9zdHJlc3NdCitmaWxlID0gaXBpX3N0
cmVzcy5mbGF0CitleHRyYV9wYXJhbXMgPSAtY3B1IGhvc3QsLXgyYXBpYywtc3ZtLC1oeXBlcnZp
c29yIC1nbG9iYWwga3ZtLXBpdC5sb3N0X3RpY2tfcG9saWN5PWRpc2NhcmQgLW1hY2hpbmUga2Vy
bmVsLWlycWNoaXA9b24KK3NtcCA9IDQKKwogW3ZtZXhpdF9jcHVpZF0KIGZpbGUgPSB2bWV4aXQu
ZmxhdAogZXh0cmFfcGFyYW1zID0gLWFwcGVuZCAnY3B1aWQnCi0tIAoyLjI2LjMKCg==


--=-XBtBz6EzfH3Aw3rcptLe--

