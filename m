Return-Path: <kvm+bounces-68288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 581F6D2B52D
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 05:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3450D3085061
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 04:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53405345CA8;
	Fri, 16 Jan 2026 04:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vr5Shc5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC4A3451B2
	for <kvm@vger.kernel.org>; Fri, 16 Jan 2026 04:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768537421; cv=pass; b=T069t7p9pLVnB3EUBqp3t+XEUUE9ldY8PcH5QEby1L5o3SBsQvAiVG4Tc3YdHN9/84FuI9PMznBHdQ6heq9Vxfi9OdUlSb5WGXOnxlGn9XJrj7pnABcVfDRr8VIEBzbMIuy278akPvoescnP7uvkU7YHG2q/oPs8nDVngSO7etQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768537421; c=relaxed/simple;
	bh=t9W/scSXovPATZ+gq3bWTCsz5jE4rtYjFSKZcQ2zPks=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=bqOSS72Fw/6DjxMzuyIJHKhO9YWlSsK+KJ5cCRRW8zdFSXEf8k/zw/oszPciwZLovObVgMa+hWSeqFq9UeiYTrhjxucjmBmStcSsBh4PJqLawfQUrHSgkppYc0zLFL/I34d3fnS+Dq9uAY5s9zyaCSCAxNeLD41fwkL4ng1aFfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vr5Shc5; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so4749a12.0
        for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 20:23:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768537418; cv=none;
        d=google.com; s=arc-20240605;
        b=deBvgUfAS77TCbs6u16IH08O8grK842XaUaOBU4fCp2JOC/sF8pKG9jsIjKp4nZLYF
         6QgU/AGLrGV+hcHleVGAYF7enlxpzXS5tyTmX170DtegGImCtssmzAiVFkCoXUnInwgf
         OXyw2AxZU3VNLD2wIH2OSmVfsG8qQvgnAtdm0NN31VHmjfXu8UMJbXG0pXKGBfA/CKIk
         9w8fATi2u7LbIymszFSesGlt82qHqiyvR/FUqHfgaca6XjuDcCRw6dkORCeyLHBPQuR4
         qTuZCgg2p1HgJjk16Kh4HuEBMebhhmMl6ims8MJQi7S1lBmHM43u/t91od2S+02kxPTT
         Jbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CQBnNlpZCgFRekPGXIOEqkC5tJTqz8MzcUs9mWtjz+I=;
        fh=xmC3HlrkloksW4rPU1rexLV8t6q71lRAq3RGXGfOTDo=;
        b=AdO5ewtZkLEcNUxU+0lO/NksxNjKUP4zUmVkZszmWwTG375s0DzEEDlzcEA7SgGHzf
         wUp10BfMo6nWBxgK3fWS7s757BN756GUgXf9bMGfC1B6/ZmyQJxtaGzxljAMvtW3IGj3
         ty5KOKO+W1lANV7DgGWqw5rFVOK2tmnY2t5N60u9qcX7h42ygw24/2kXOPRvo5MXhNUM
         e1ac8Qoz7xtpzdEbpRNBK9Z8wqD0CQO9S1+We6n28hCkE8gwCwIS+yZ88DjGX3lzyF4d
         DrK57bKxkwhy3uyeJp0zQjRKh5QURvQYZJJ/xwCnlGiAEmblMIIRbsb4PYGmWarZoBmQ
         suBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768537418; x=1769142218; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQBnNlpZCgFRekPGXIOEqkC5tJTqz8MzcUs9mWtjz+I=;
        b=4vr5Shc5il0eVKwj+zgp+iu3NPwgvb6L33NSZ+LCCzo3QwlSnnc6o+zXobQvnpX1Sh
         Azf1HGasfTxSdyFb7rL3ygtG8GTCwjIWAXFr0pwV/pbjetgXwV+DflmNsjARYnFNr/3G
         6+R/p5M6qf48TG+TXVWzv2h3dnpGs0MpJf+ZlGuvigJpejNYH8wIx7Q9zt4XS9hUvGhF
         1tuLhDvbGebk2BOzXNhJSl3yqYWlq4dRyqQ4rjJ7SdWF9cRDGIlco/Mb0kWqiCbY2UbW
         Wa3mjlOK3mQfrq/npj5vKva3AxE4g6BJr54BkSS+XLPErgiwixWjVoDW78o5iIO6Rfgc
         2FSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768537418; x=1769142218;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CQBnNlpZCgFRekPGXIOEqkC5tJTqz8MzcUs9mWtjz+I=;
        b=QFLLlF+YI5und0ORbeJ6pe+yYuoZgx0s+7M4jgGiw8CnUcDC9B0hSYHVpGuZ92dTre
         K7Imd/Ev/y6HLXvUphVnfidCNxX17tc5I0I8QOoTKsRnS1cnsoYXWK8C2lPTWqqyMrQV
         H/7Cvhu80l7OQBD7U9MsNIJ6XGb1/gn6SfsvjcvZ2WJRgXwu3IxQmDGNee1Y/6guSOqc
         cqme6pnQw3OMKAkrDCRWRtYQpaIgkhaFOgJoldc6GY8F+chhGKY9hBaCN/I4U9jS9XmK
         JgrHQWnJG6vAgLG9H+1ymi2OSnhKZNwDtEN/QrHHu0ouGHD/6GWMO0lymdzt+P5c6MEI
         YPIA==
X-Forwarded-Encrypted: i=1; AJvYcCWRZmQJQAJkXCc5skwgHHpAdxSHGfe+kKb5j7LZHrFZoadyXWEaz2VOTQ8aIVqbyQtNVBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHGZPYNYf/6wfPdT4rZlGCm12ZZtLyhcEe7K30GZvJ/wj4VS6Y
	FH2+nz9zeLZ9VInWaYOhvohqzLq/IU38hvtqlyxcULeuDBYPdz5PbaC7RJxKiKBZiT0duVWrfl1
	mELbrF7pWQXi1sTpJQjlzsS4bG0ugi8DDvY71Z1Gg
X-Gm-Gg: AY/fxX74zLkexVaOpGY7HDf17Rbsppksqy1q6R4voTGTu8EJ5lQADmilDG1GJcbkohL
	6duv0nPi8MCARusyjkAa9ZZCSVZY5KhxoXAqbihJIoM9nYA/D0uHrPIyGMjsdW77+cgaG7z8IRp
	pixxOWWqWd2pKdmljXxaOs5QJUmHAqCqDKBxEOxWzlrnl0Ipa43S4+5kxZJ+HIdZJ61wdlY/rit
	Gf9kzsyaVQ4YaHFKsSmgsfudILgTJ7WwdkFefgl1aMdcGUbupKK4vzU1rgIHD+NK5/sj6E=
X-Received: by 2002:a05:6402:345b:b0:649:8aa1:e524 with SMTP id
 4fb4d7f45d1cf-655251ec768mr12527a12.11.1768537418027; Thu, 15 Jan 2026
 20:23:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115232154.3021475-1-jmattson@google.com> <20260115232154.3021475-7-jmattson@google.com>
In-Reply-To: <20260115232154.3021475-7-jmattson@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 15 Jan 2026 20:23:26 -0800
X-Gm-Features: AZwV_QiDkq2kwy7nbR9fUAEWefj2zSCFllDeLOP7A8FMqaeIEAaTMQ6drundYUU
Message-ID: <CALMp9eRGSoQGu9R7CYqgRERY=x-_=59bHvEab-t519u8n6nmWA@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 3:22=E2=80=AFPM Jim Mattson <jmattson@google.com> w=
rote:
>
> Add a 'flags' field to the SVM nested state header, and use bit 0 of the
> flags to indicate that gPAT is stored in the nested state.
>
> If in guest mode with NPT enabled, store the current vmcb->save.g_pat val=
ue
> into the vmcb save area of the nested state, and set the flag.
>
> Note that most of the vmcb save area in the nested state is populated wit=
h
> dead (and potentially already clobbered) vmcb01 state. A few fields hold =
L1
> state to be restored at VMEXIT. Previously, the g_pat field was in the
> former category.
>
> Also note that struct kvm_svm_nested_state_hdr is included in a union
> padded to 120 bytes, so there is room to add the flags field without
> changing any offsets.
>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h |  3 +++
>  arch/x86/kvm/svm/nested.c       | 13 ++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/=
kvm.h
> index 7ceff6583652..80157b9597db 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -495,6 +495,8 @@ struct kvm_sync_regs {
>
>  #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE        0x00000001
>
> +#define KVM_STATE_SVM_VALID_GPAT       BIT(0)
> +
>  /* vendor-independent attributes for system fd (group 0) */
>  #define KVM_X86_GRP_SYSTEM             0
>  #  define KVM_X86_XCOMP_GUEST_SUPP     0
> @@ -530,6 +532,7 @@ struct kvm_svm_nested_state_data {
>
>  struct kvm_svm_nested_state_hdr {
>         __u64 vmcb_pa;
> +       __u32 flags;
>  };
>
>  /* for KVM_CAP_NESTED_STATE */
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 5fb31faf2b46..c50fb7172672 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1789,6 +1789,8 @@ static int svm_get_nested_state(struct kvm_vcpu *vc=
pu,
>         /* First fill in the header and copy it out.  */
>         if (is_guest_mode(vcpu)) {
>                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
> +               if (nested_npt_enabled(svm))
> +                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VALID_=
GPAT;
>                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
>                 kvm_state.flags |=3D KVM_STATE_NESTED_GUEST_MODE;
>
> @@ -1823,6 +1825,11 @@ static int svm_get_nested_state(struct kvm_vcpu *v=
cpu,
>         if (r)
>                 return -EFAULT;
>
> +       /*
> +        * vmcb01->save.g_pat is dead now, so it is safe to overwrite it =
with
> +        * vmcb02->save.g_pat, whether or not nested NPT is enabled.
> +        */
> +       svm->vmcb01.ptr->save.g_pat =3D svm->vmcb->save.g_pat;

Is this too disgusting? Should I extend the payload by 8 bytes
instead? It seems like such a waste, since most of the save area is
dead/unused. Maybe I could define a new sparse save state structure,
with the ~200 bytes that are currently used, surrounded by padding for
the other 500+ bytes. Then, I could just grab 8 bytes of the padding,
and it wouldn't seem quite as hacky .

>         if (copy_to_user(&user_vmcb->save, &svm->vmcb01.ptr->save,
>                          sizeof(user_vmcb->save)))
>                 return -EFAULT;
> @@ -1904,7 +1911,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vc=
pu,
>                 goto out_free;
>
>         /*
> -        * Validate host state saved from before VMRUN (see
> +        * Validate host state saved from before VMRUN and gPAT (see
>          * nested_svm_check_permissions).
>          */
>         __nested_copy_vmcb_save_to_cache(&save_cached, save);
> @@ -1951,6 +1958,10 @@ static int svm_set_nested_state(struct kvm_vcpu *v=
cpu,
>         if (ret)
>                 goto out_free;
>
> +       if (is_guest_mode(vcpu) && nested_npt_enabled(svm) &&
> +           (kvm_state.hdr.svm.flags & KVM_STATE_SVM_VALID_GPAT))
> +               svm->vmcb->save.g_pat =3D save_cached.g_pat;
> +
>         svm->nested.force_msr_bitmap_recalc =3D true;
>
>         kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
> --
> 2.52.0.457.g6b5491de43-goog
>

