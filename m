Return-Path: <kvm+bounces-15842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A778B0F5C
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 118901C20AE9
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 16:06:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C288161310;
	Wed, 24 Apr 2024 16:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DIglwk3K"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0315E1E3
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 16:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713974774; cv=none; b=XyDSiu7ne4QrGzwCGG143lZagOIFNkNCyyiaErtoxvltkF+S/B32ZcMUkGEeH3ujBsteK0LSCEMbPrBfv4/1/Y40y0BpLLqYAJ/oxx/mb9aP70ej2EwiaCVPSm2vJGnxLSX9+Yqw2IffdcreR1YXcdZoM0GIL63RjtJqYf6iySU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713974774; c=relaxed/simple;
	bh=yVhTaSI0IN9x1hSEq/c6WtpXjjzz5sgC1B4mc1Aq4Vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGxz+r70mZusoSVn9458/OgsQpXgvwZkGnH3z/xxuoZJrlqiQhQ/Ep1naHMeZ3w3I6Ks3v2KZtX/fLnA1vrdwj8uhAP6YnSf/8AF7wNzcWh8tcVI0c9a/2w+EC+OSneBtuhVASDsw10yBXVAvCaF9/rlVGgk6dnzNy1TWIe6zEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DIglwk3K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713974771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oA2yVR/0LIk/2yMOm6WFAwy5uxXi3mXUTspZx4CPJrQ=;
	b=DIglwk3KaOMPKLBl1JfW8Sjqb+tr0C0HLwlRooXd9NL4AWhWM/22SKin9QUpn6y5WpnWdm
	PjCcOyo/HtxPanzW2OVIIs6iruLMrqae/VHPum1TS7ER+gXxjQOnMSTlJju2UcMvwVuy2f
	Az2W2iJyjFianh2K2A8Zqbp3PJFBoV0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-HfrQNEsHPY6U-yzVmxVxng-1; Wed, 24 Apr 2024 12:06:10 -0400
X-MC-Unique: HfrQNEsHPY6U-yzVmxVxng-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-343c6a990dbso26190f8f.1
        for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 09:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713974769; x=1714579569;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oA2yVR/0LIk/2yMOm6WFAwy5uxXi3mXUTspZx4CPJrQ=;
        b=iR7thUQM2FCrznHIMLoXCtIayQ6SNplXHeoZRCbyVoCyRrugaTD25pk5l8a9y+4VYT
         w11cat955rVGL8KAVcsgasQBWRJAXEe2GAuytVgg2Ele4RW/wmVV2xw0eZV+Rr59wAM/
         sK4DthSPuA4H41ilIVcfVDjJEwREVsGzwFmq+thWKkok8ch2rURsrjhjRCi9yXHVt3Vo
         21xSzXiIiwj7JozRQUk6oY2biYXyBTsKRN9/wFwqDNpBBVU0tD1EN9ayEJHIDLf8Lkly
         HIHR4z/Cfzx4TO2lOh/PLRr+OOFicphsXg9uGRUwpdXw50YyVoEknq1n+PiZwGGRRF/q
         TdIw==
X-Forwarded-Encrypted: i=1; AJvYcCVbrCsVx/iovij62zK3q5kFJWPt8I/mLGRMIzRlJ+63BCRA4trTUTOOaG3oWjdf07ObpcqwLGuQz6LLeWkhP4CLO5GY
X-Gm-Message-State: AOJu0Yxszzks8go4E+sjoZYjEIaDEWS7Pa8Oxou78osYdUdD1PvjhCSZ
	V7Y1DllTUsw26AlxwwCKgUvsCPTEtIlrrvCbjC5byoSUn8KcwdkreEOjGktT5JDFrhhGbUNlyur
	jpzvVzNZDG3kRSDPF6POYyzCTqaKjzcxsoDaQPm1qJh2ZR9Fgt7HoiEIsZkQyF+HmI6J+uqQmDc
	1j3M1mCI4+lezmJyanvNUuc2Yy
X-Received: by 2002:adf:f451:0:b0:348:7e75:4d75 with SMTP id f17-20020adff451000000b003487e754d75mr80672wrp.22.1713974769369;
        Wed, 24 Apr 2024 09:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFetSybQAphKK1G77Kg0f223/o7zJ35zY1t5heqCwOVkh5YZgj4h8hG3maYM68P0r0G2V3JT9rVm9GqhLJehWo=
X-Received: by 2002:adf:f451:0:b0:348:7e75:4d75 with SMTP id
 f17-20020adff451000000b003487e754d75mr80653wrp.22.1713974769028; Wed, 24 Apr
 2024 09:06:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240419085927.3648704-1-pbonzini@redhat.com> <20240419085927.3648704-3-pbonzini@redhat.com>
 <eb7c7982-2445-4968-892c-c36f5b38fabe@linux.intel.com>
In-Reply-To: <eb7c7982-2445-4968-892c-c36f5b38fabe@linux.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 24 Apr 2024 18:05:57 +0200
Message-ID: <CABgObfYrxwdy-LqcWiCSfHhOihi9qJT2a3PzhSRHzkFgiJurNQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: Add KVM_PRE_FAULT_MEMORY vcpu ioctl to
 pre-populate guest memory
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	isaku.yamahata@intel.com, xiaoyao.li@intel.com, seanjc@google.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 7:39=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.co=
m> wrote:
> range->size equals 0 can be covered by "range->gpa + range->size <=3D
> range->gpa"
>
> If we want to return success when size is 0 (, though I am not sure it's
> needed),
> we need to use "range->gpa + range->size < range->gpa" instead.

I think it's not needed because it could cause an infinite loop in
(buggy) userspace. Better return -EINVAL.

Paolo

>
> > +
> > +     vcpu_load(vcpu);
> > +     idx =3D srcu_read_lock(&vcpu->kvm->srcu);
> > +
> > +     full_size =3D range->size;
> > +     do {
> > +             if (signal_pending(current)) {
> > +                     r =3D -EINTR;
> > +                     break;
> > +             }
> > +
> > +             r =3D kvm_arch_vcpu_pre_fault_memory(vcpu, range);
> > +             if (r < 0)
> > +                     break;
> > +
> > +             if (WARN_ON_ONCE(r =3D=3D 0))
> > +                     break;
> > +
> > +             range->size -=3D r;
> > +             range->gpa +=3D r;
> > +             cond_resched();
> > +     } while (range->size);
> > +
> > +     srcu_read_unlock(&vcpu->kvm->srcu, idx);
> > +     vcpu_put(vcpu);
> > +
> > +     /* Return success if at least one page was mapped successfully.  =
*/
> > +     return full_size =3D=3D range->size ? r : 0;
> > +}
> > +#endif
> > +
> >   static long kvm_vcpu_ioctl(struct file *filp,
> >                          unsigned int ioctl, unsigned long arg)
> >   {
> > @@ -4580,6 +4629,20 @@ static long kvm_vcpu_ioctl(struct file *filp,
> >               r =3D kvm_vcpu_ioctl_get_stats_fd(vcpu);
> >               break;
> >       }
> > +#ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY
> > +     case KVM_PRE_FAULT_MEMORY: {
> > +             struct kvm_pre_fault_memory range;
> > +
> > +             r =3D -EFAULT;
> > +             if (copy_from_user(&range, argp, sizeof(range)))
> > +                     break;
> > +             r =3D kvm_vcpu_pre_fault_memory(vcpu, &range);
> > +             /* Pass back leftover range. */
> > +             if (copy_to_user(argp, &range, sizeof(range)))
> > +                     r =3D -EFAULT;
> > +             break;
> > +     }
> > +#endif
> >       default:
> >               r =3D kvm_arch_vcpu_ioctl(filp, ioctl, arg);
> >       }
>


