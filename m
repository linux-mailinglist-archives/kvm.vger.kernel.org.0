Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A86EA1545E9
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 15:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbgBFORN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 09:17:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727060AbgBFORN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 09:17:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580998632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=07gd7gdweIOy39pTPvnuNu/vUJNdEFHQ8hzDybfwE4U=;
        b=dRFkLO04HSaHujh3FaMlfpKhV7zkDq280pkY/TGNEWvWDVZiNIJFHZokzcxd6ah2B1qBGb
        jZQTM8dHfcqIyJCrNauFUbZNvcdq/yXTZ9zr7LiTSTbsmxKpTUIE+tbAi+nUr2gsQT/yB+
        qLpCiBrkbGw2NLubkOdIvRbSbvqqWm0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-PXFNNANLNL-tyYr_uMzYYg-1; Thu, 06 Feb 2020 09:17:10 -0500
X-MC-Unique: PXFNNANLNL-tyYr_uMzYYg-1
Received: by mail-wr1-f70.google.com with SMTP id n23so3430648wra.20
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 06:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=07gd7gdweIOy39pTPvnuNu/vUJNdEFHQ8hzDybfwE4U=;
        b=Jed96cvS+N1Dm7Y0fBr46fIsXDAfC/o4Yij5b+KK7qkpU4v1lQysAQaARJA+RQihza
         YvFnlVzIEutDeERORbVRgEO+tgNAzXXTQl5pB5VEBXuEQJRngNpzFwgqBIPKjymO4lpl
         eQ/DsuYVn/nQUW3LOq006dJsVrCnurj61S6nj5yhGXs6zrKFKUpprP7u97A4TT9ozkHm
         Q5IgNBEPFgFKoCuj5CkMBuz2FVSnagk7xvw4BdzXbG1fV0Pvu0GUEveA5JguKhtHwyAt
         cqZsZiIanNWwd9O69dFeGcbZkaMQ5s+R3v5HW66waJ3tz2jvwlP2CN+550+gMWY9srz6
         eknw==
X-Gm-Message-State: APjAAAXiI65p/9CIxgHijD2QVpkf3apbS4IUl3KuDjF1cwX76LinPr+z
        VX/BdefS/oYZNsw3n9+KbkC28OxIWtJXRcmNvcIolTZ/+l+hKEVuBMa8170NviGxI9rBdUVLbS9
        bsTZbN793j/n5
X-Received: by 2002:adf:ce87:: with SMTP id r7mr4002440wrn.245.1580998628181;
        Thu, 06 Feb 2020 06:17:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUc4CdZTILhzVi27Kj5fMUhgBxHWENUsjzPNPmZVLMx8Pt04I1MX+pQMKzcRQHLf6jqdashw==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr4002421wrn.245.1580998627893;
        Thu, 06 Feb 2020 06:17:07 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id v22sm3757493wml.11.2020.02.06.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 06:17:07 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     dgilbert@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: relax conditions for allowing MSR_IA32_SPEC_CTRL accesses
In-Reply-To: <1580915628-42930-1-git-send-email-pbonzini@redhat.com>
References: <1580915628-42930-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 06 Feb 2020 15:17:06 +0100
Message-ID: <87v9ojg5r1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Userspace that does not know about the AMD_IBRS bit might still
> allow the guest to protect itself with MSR_IA32_SPEC_CTRL using
> the Intel SPEC_CTRL bit.  However, svm.c disallows this and will
> cause a #GP in the guest when writing to the MSR.  Fix this by
> loosening the test and allowing the Intel CPUID bit, and in fact
> allow the AMD_STIBP bit as well since it allows writing to
> MSR_IA32_SPEC_CTRL too.
>
> Reported-by: Zhiyi Guo <zhguo@redhat.com>
> Analyzed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Analyzed-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index bf0556588ad0..a3e32d61d60c 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -4225,6 +4225,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>  			return 1;
> @@ -4310,6 +4312,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		break;
>  	case MSR_IA32_SPEC_CTRL:
>  		if (!msr->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
>  		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
>  			return 1;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

but out of pure curiosity, why do we need these checks?

At least for the 'set' case right below them we have:

        if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
                 return 1;

so if guest will try using unsupported features it will #GP. So
basically, these checks will only fire when reading/writing '0' and all
features are missing, right? Do we care?

-- 
Vitaly

