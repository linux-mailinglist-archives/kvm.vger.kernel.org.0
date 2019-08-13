Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E088B2D5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 10:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfHMIrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 04:47:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55403 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfHMIrk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 04:47:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so713664wmf.5
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2019 01:47:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dot1gc/mMlmPmCzz2QNsuI+h9x0oQ5vgk6vGPP9o7BE=;
        b=RnwQhnztQ4UsSXnho0JnwsScsahp16Beh49wLmrFbt+o/y933+zd9FUPOnoWqNixhL
         W6G+GVvV3jyxFFToA5uxjoeA0gccM0r8hFED/L67EQWx1l0ExUdkZiRU+3wTAzddKsQi
         dfNHbosV+sqtf7qs/yWbWZH71Sz2bNHqcGfPfd4hyhJlxSgxymwVz0inbNhfbxCA1Aaz
         EZKnyJFoNTNIGhAiBA1bTk3dE6nn1dN87hiRpbR4kdXhrKZO5gcgC0AsDqy1b8jZqDx3
         wTbjLVuG4rbvez+yIGX+sv75GVrCWRe2GoM9NJeNgA4JXIjj69p3pKbJSJobMehJPU2N
         FP4A==
X-Gm-Message-State: APjAAAXQqk4D7NRDCBcmQ4UpK8OC+ionat+QFoiADC1UyAgsWFBXj3qb
        PL73+BC75cEHsFfsC0vTDJLUdQ==
X-Google-Smtp-Source: APXvYqzu741BNphc7Bkte8hG3txzzfxmRNvj7kUnHgJredomsRJ9fKepXbx6ZmCo5ts7buHZQwE5Qw==
X-Received: by 2002:a1c:2ec6:: with SMTP id u189mr1791329wmu.67.1565686057680;
        Tue, 13 Aug 2019 01:47:37 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w15sm832270wmi.19.2019.08.13.01.47.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Aug 2019 01:47:37 -0700 (PDT)
Subject: Re: [RFC PATCH v6 75/92] kvm: x86: disable gpa_available optimization
 in emulator_read_write_onepage()
To:     =?UTF-8?Q?Adalbert_Laz=c4=83r?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?Q?Samuel_Laur=c3=a9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Yu C Zhang <yu.c.zhang@intel.com>,
        =?UTF-8?Q?Mihai_Don=c8=9bu?= <mdontu@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-76-alazar@bitdefender.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <eb748e05-8289-0c05-6907-b6c898f6080b@redhat.com>
Date:   Tue, 13 Aug 2019 10:47:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809160047.8319-76-alazar@bitdefender.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 18:00, Adalbert Lazăr wrote:
> If the EPT violation was caused by an execute restriction imposed by the
> introspection tool, gpa_available will point to the instruction pointer,
> not the to the read/write location that has to be used to emulate the
> current instruction.
> 
> This optimization should be disabled only when the VM is introspected,
> not just because the introspection subsystem is present.
> 
> Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>

The right thing to do is to not set gpa_available for fetch failures in 
kvm_mmu_page_fault instead:

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 24843cf49579..1bdca40fa831 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5364,8 +5364,12 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u64 error_code,
 	enum emulation_result er;
 	bool direct = vcpu->arch.mmu->direct_map;
 
-	/* With shadow page tables, fault_address contains a GVA or nGPA.  */
-	if (vcpu->arch.mmu->direct_map) {
+	/*
+	 * With shadow page tables, fault_address contains a GVA or nGPA.
+	 * On a fetch fault, fault_address contains the instruction pointer.
+	 */
+	if (vcpu->arch.mmu->direct_map &&
+	    likely(!(error_code & PFERR_FETCH_MASK)) {
 		vcpu->arch.gpa_available = true;
 		vcpu->arch.gpa_val = cr2;
 	}


Paolo

> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 965c4f0108eb..3975331230b9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5532,7 +5532,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
>  	 * operation using rep will only have the initial GPA from the NPF
>  	 * occurred.
>  	 */
> -	if (vcpu->arch.gpa_available &&
> +	if (vcpu->arch.gpa_available && !kvmi_is_present() &&
>  	    emulator_can_use_gpa(ctxt) &&
>  	    (addr & ~PAGE_MASK) == (vcpu->arch.gpa_val & ~PAGE_MASK)) {
>  		gpa = vcpu->arch.gpa_val;
> 

