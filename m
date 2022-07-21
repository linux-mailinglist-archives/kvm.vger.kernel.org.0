Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FE57C1AC
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 02:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbiGUAib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 20:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiGUAia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 20:38:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16613753B9
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:38:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id r24so345960plg.3
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 17:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qIXB7whg+5LKxcRErmf7YwO5OWBbWQDJ0V2XnbTZNg4=;
        b=BACRZqGDzXNofGzcoYRAS2JjGiCOrkPjVYzQ3lKxaNcbSVSMwv4PaCdFhQz33SC/56
         bU7oo7Wzi39irAkMrCZ2rXJp08uAcaW1ogwtKBcXg2TrY72p1CRXLsr9vQBUfEeZqFAM
         kgsXD99MjdByuEqDgbrnnkJqdPZpIOT1AAICubSLwc1ziYsOeZeFO7ZZNVXxjRLoZTej
         sIhHSez5sJskV1l5EMmUbELRdx+Q033WY546bBSLpGZvVVKh9s+eZxefAFhoDxZbgA11
         Ipo3YEUQNY8+a2dzp4UOGZic4/UjROC3ROGikEZfpyO9YJ0iQjCU/3uieJmU4c9le9gi
         XCcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qIXB7whg+5LKxcRErmf7YwO5OWBbWQDJ0V2XnbTZNg4=;
        b=IlemS+fohKnQ5/I1f4dF1pJ8tr/65MOAoTV3m34OSiqH6GSaocp0RSsVTBPpI51Sz3
         r7axZrHJYkJdlQQd6kc0P2BeTSv+0W8nZpxPqiReyaDJijK74KSOAZqfzTpWDEdJvFU1
         PO+WGBWLRQs5P7G6EJLFMz8iWfv+w3IqTLNmW84oyUUok45g9OF9rmab377HmHAnryXl
         XYEqEu/6c4rs42WRnHbWtlAPdpfO5Vj1XVLchS0jw5+/5EjDrbRyjktePCPPUnPjAd0V
         rjH7O8hGNAoYZqzwOULZa7v9sHvb4y1tIW39hiRLyOtStsXy2oIQIHSCaDXPVlQ5Wec7
         Qw6w==
X-Gm-Message-State: AJIora/MNkaLP0pJZm+qnGGAww50rABGb35bKxoipoaYFZsRQR3g8vlv
        Y5udz9x95yKu5kmuWCxxX4j6/Q==
X-Google-Smtp-Source: AGRyM1uh11Q9cdp3jm/parZ80PTYH/PGg1DPcFzwpRjaXgM4jNO+OmAJzFdk7fBt01oISacfNg5A0g==
X-Received: by 2002:a17:90b:1c8c:b0:1f1:be0b:8903 with SMTP id oo12-20020a17090b1c8c00b001f1be0b8903mr8541666pjb.160.1658363908283;
        Wed, 20 Jul 2022 17:38:28 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ab8700b001677fa34a07sm176882plr.43.2022.07.20.17.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 17:38:27 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:38:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v2 09/11] KVM: x86: emulator/smm: use smram struct for 64
 bit smram load/restore
Message-ID: <YtigALu4ccTi4/v0@google.com>
References: <20220621150902.46126-1-mlevitsk@redhat.com>
 <20220621150902.46126-10-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621150902.46126-10-mlevitsk@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 21, 2022, Maxim Levitsky wrote:
> Use kvm_smram_state_64 struct to save/restore the 64 bit SMM state
> (used when X86_FEATURE_LM is present in the guest CPUID,
> regardless of 32-bitness of the guest).
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
> @@ -9814,7 +9805,7 @@ static void enter_smm(struct kvm_vcpu *vcpu)
>  	memset(buf, 0, 512);
>  #ifdef CONFIG_X86_64
>  	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
> -		enter_smm_save_state_64(vcpu, buf);
> +		enter_smm_save_state_64(vcpu, (struct kvm_smram_state_64 *)buf);
>  	else
>  #endif
>  		enter_smm_save_state_32(vcpu, (struct kvm_smram_state_32 *)buf);

Hrm, I _love_ the approach overall, but I really dislike having to cast an
arbitrary buffer, especially in the SVM code.

Aha!  Rather than keeping a buffer and casting, create a union to hold everything:

	union kvm_smram {
		struct kvm_smram_state_64 smram64;
		struct kvm_smram_state_32 smram32;
		u8 bytes[512];
	};

and then enter_smm() becomes:

  static void enter_smm(struct kvm_vcpu *vcpu)
  {
	struct kvm_segment cs, ds;
	struct desc_ptr dt;
	unsigned long cr0;

	union kvm_smram smram;

	BUILD_BUG_ON(sizeof(smram) != 512);

	memset(smram.bytes, 0, sizeof(smram));
#ifdef CONFIG_X86_64
	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
		enter_smm_save_state_64(vcpu, &smram.smram64);
	else
#endif
		enter_smm_save_state_32(vcpu, &smram.smram32);

	/*
	 * Give enter_smm() a chance to make ISA-specific changes to the vCPU
	 * state (e.g. leave guest mode) after we've saved the state into the
	 * SMM state-save area.
	 */
	static_call(kvm_x86_enter_smm)(vcpu, &smram);

	kvm_smm_changed(vcpu, true);
	kvm_vcpu_write_guest(vcpu, vcpu->arch.smbase + 0xfe00, smram.bytes, sizeof(smram));

and em_rsm() gets similar treatment.  Then the vendor code doesn't have to cast,
e.g. SVM can do:

	smram->smram64.svm_guest_flag = 1;
	smram->smram64.svm_guest_vmcb_gpa = svm->nested.vmcb12_gpa;

That way we don't have to refactor this all again if we want to use SMRAM to save
something on Intel for VMX (though I agree with Jim that that's probably a bad idea).
