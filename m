Return-Path: <kvm+bounces-71351-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8H3fNL3xlmmYrQIAu9opvQ
	(envelope-from <kvm+bounces-71351-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:19:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8065A15E37F
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 12:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BA816300D4D8
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 11:19:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9B233DEC0;
	Thu, 19 Feb 2026 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VwWHERRv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q6T/Qbmh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70546333729
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 11:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771499960; cv=pass; b=WGSJsZwP/WNnZVmE8iAYFZ+cL0tQCu4KRdBQ28cwdFXqn2LWTn9Auo/0Fre5ooIt3/HPY0lWWGO1BxRH658lbQSBe134lDwObsNTs5KekGY/mOY+5nbEgstatdy1mXR861tDgXJ+s89IuOIkPMsfusrubRG+F+0mwV4HmD8VQrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771499960; c=relaxed/simple;
	bh=GeVpMcesSAeemlkNgpZW5Vjk6hi7nuGzJLl/n6XQmMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/HPpLwZGKdUh6f1HjKpOhYT5ULwoRB5CyW1eNyAGbgkR1///oQRidl8R4XDebckz8iw2xjOcFQLyNPMrG7WxeqQKeew+lvff8XFAlhrHsQJNHrw3dRE5TMUudJXKotwAoCfX/AGlmgUixYfNtwZ4OTlqhDWlcksMF78h4Ze2Nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VwWHERRv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q6T/Qbmh; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771499958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/VQ4ZrNL9Qa/cscOHEjIGN/9BDBmCD3BxFkmi6QtEHQ=;
	b=VwWHERRv8p7q5KGoSTAN/aoONdSsqlpdbfjidopy3KgSSZe98Aq/ixNCA1TqOs1ONBN/rB
	50hJLafIKbcvs27DVz3CmbuAVAoW2TdYzbnFJuHrHY5hCQiUFgFX0T+3zZSc9XNRdSHkJp
	b3KFtKQVUIK0Q/UmCspHA7ePQg9YUCE=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-342-gUMQxBddOiWCFT25LYuAHw-1; Thu, 19 Feb 2026 06:19:15 -0500
X-MC-Unique: gUMQxBddOiWCFT25LYuAHw-1
X-Mimecast-MFC-AGG-ID: gUMQxBddOiWCFT25LYuAHw_1771499955
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-506b1524dfeso61989391cf.2
        for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 03:19:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771499955; cv=none;
        d=google.com; s=arc-20240605;
        b=NuZNZguum4AUq3Hzbfu9dswOAVavFS3iYKb6XT3X1tPWJLWb/F4KSVvNwqNeuDAvKA
         cqfVwnpFl/xTCtR+JI6pYvpGLR0obyL0tGJEBDCKFA8mmMC14XgW8Gi1+lwsmRFY32C8
         AcKYYLcTyeuNzdwxWkU4tfY6Klm/3Qq5w17ejVBQ6NI9iZHhgsGhknCGMww/IIA9ioNW
         udPX9fLhOUGsnTFqv2ftFBAIGXSylfv8LmaKiyZ2/8/Q14DhIukU3gMT1TeujtjEMyVt
         Tjscng3kmYhHmfgJHEUz957ZdB3YdyROflKjd4Psjmjru7qZhLnk6KClmhKl0kCEQ8I1
         QpSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/VQ4ZrNL9Qa/cscOHEjIGN/9BDBmCD3BxFkmi6QtEHQ=;
        fh=uKqvod+pRY9I2bk3ogmSgfyVwT2Y7VnyXuTrDCwBgWg=;
        b=FFSwR5qGiAUOADQ7dL20ZMNpiaDqmldkig4zEvaMbDi/MDlUQhYQDf4RfxhR0XQC/P
         bWdLKoZ/o41MCDB/JXQN+FDJT/iQ7DuA2nxxTBhAtVD7zf+KvQGpGwm/aFPCCfXjyRik
         UIySZ2+NeBi7tkwdvmPgoL2ZY1mhH3MYOJAV6m+iUdkQ3GFmHQ6Ygy1vj5MBcSr3RgbL
         +EVT93KbisKWUWyCbPoNOCeibifg7AqQeWvTpp4iQngjJLVkNAfk/MADbJyCJmlTo8VE
         nnPLWADPMbm07GQcbEdv+QnGF/+RiApFsCcXl3Y8zTZ+p2WXMXm5pc15ZuZHAspzIpGI
         Hynw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771499955; x=1772104755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VQ4ZrNL9Qa/cscOHEjIGN/9BDBmCD3BxFkmi6QtEHQ=;
        b=Q6T/QbmhG+WlSpkCgaNLJ8oKtS20L43pQQnubewBn3GCGkqD0YJvAH4gsLn7nLRl9T
         J1TktY4rDjlqvqlG0IjY+Pdg6M680nmTZQR8g2SpLw0Rp6rht676iF/UEqwNCpd7b+4a
         NSkRmSQDaYMpwLJFM61TMwbkSB+c9phS6Qn/h83rO5MS6E6e4rn89BAqUP6MJFjWKUuC
         dH6mDKMJ2nn8fcsvlg6tiwewYV370iQ/IeYANR9WGPYweNRzNb5IvTNkYEhH08XnAuYw
         5P3BNVYOa8wRrn8+kRqInPUGEvc4cCfHCfkfYTGjzs7aK8sbthzx4zo/oGqv0QO6Mpqt
         TMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771499955; x=1772104755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/VQ4ZrNL9Qa/cscOHEjIGN/9BDBmCD3BxFkmi6QtEHQ=;
        b=ArS8lrGoVFy9mjrvQuzW5PxR6YbAQ+6vtFJxZMomSnWvtZy43fcD/OzBu8G4b/xxH2
         4BVcFygAlHRgBVuruvUmsmuS0S/lMCA6CeXb7v/bIeVQ50kB5AYJT4MeIgYJ5VuKBu8Q
         /EWFDNcFCC4rgw/8HRruFje+M0hdjy3pj0VkKJn6LGkKHpfg3KFghVtH8+1x2Vxk6pY8
         kFshkqbgcB9I6suVK3VprHGdaFw+SMF3AKW9KE+MjmW6l2gnhN7HfPiEKSWz8/i42FH1
         3Uw+5cbG9vE3cUwtfTO/8B08p2w++YwjOAlbYSwxavuAc47W704d2fUaEBcWIm98odtY
         yZiA==
X-Forwarded-Encrypted: i=1; AJvYcCWCpVsgPPv1JRcfANyFy3moosWAHoH6vW943Fj1ja6VaMlG7OKrKSaDzW4d0EYRKkkZeHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDsZwL1C0/khtnke/Q94rGSzPQmJ39qX/uxSyWGFMqm3TNW14L
	IUJ5E7rpNB4uskCDW1qQy5sEShYqR3swSGkcsw8qsd5XuuHOKhu/T1Pvs/niKtzk8H8LGtCtVDr
	OfsbYHGl9HZupLVUbsFWoUDZrf4sCjJGQY/CPw0wlJ8uux59m6ZAU+aToWPFXX+FUOMqM3627ud
	3g0ggytp6PLtURf3UeXzHl60WdYfmJ
X-Gm-Gg: AZuq6aJSGtDp0VQ9IPD9pI4ElMHwxI6xq94JgHPGgTswtCHS1QXjWPLzcEquotRbesp
	X/izYuG5kgvrYpuzpPrRRyRfxFoAcw82uZCkIT38LaGww8e4VTALZcwtsg0JrZ84+Nrr3bl0tgj
	EA+AuJI3sObCrJJbwwJ7Npyk1gcNwi6zNps7M8wn6aVu4Jf3j/06WyevGRcp9R3bt4Qv0nMMKqP
	dvojP68uMxF6mCsdvo09Vgu3A8m6i8RDMUU
X-Received: by 2002:a05:622a:11cb:b0:501:466b:5141 with SMTP id d75a77b69052e-506e91922f3mr64949921cf.18.1771499954797;
        Thu, 19 Feb 2026 03:19:14 -0800 (PST)
X-Received: by 2002:a05:622a:11cb:b0:501:466b:5141 with SMTP id
 d75a77b69052e-506e91922f3mr64949711cf.18.1771499954340; Thu, 19 Feb 2026
 03:19:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218114233.266178-1-anisinha@redhat.com> <20260218114233.266178-28-anisinha@redhat.com>
 <3b4b7b7b-7fcd-46ce-bdcb-cd1a30cf5276@xen.org> <793B549F-F866-4BF5-ABAF-A0537BA8713B@redhat.com>
 <bb43a79b-9ca9-49c4-ae88-f71991c97a58@xen.org>
In-Reply-To: <bb43a79b-9ca9-49c4-ae88-f71991c97a58@xen.org>
From: Ani Sinha <anisinha@redhat.com>
Date: Thu, 19 Feb 2026 16:49:03 +0530
X-Gm-Features: AaiRm506Zoxs0GZihV_siDPWZ6Z4Xw_WEeLFqs6Vl0xxw-3lK7Pz4L_z7LOIjiM
Message-ID: <CAK3XEhNHb6D=Moq=wcsFPDX2Dr_TBe7D9Z1EM4J5w3k+hobpuw@mail.gmail.com>
Subject: Re: [PATCH v5 27/34] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
To: Paul Durrant <xadimgnik@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org, 
	qemu-devel <qemu-devel@nongnu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71351-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8065A15E37F
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 4:15=E2=80=AFPM Paul Durrant <xadimgnik@gmail.com> =
wrote:
>
> On 19/02/2026 10:31, Ani Sinha wrote:
> >
> >
> >> On 19 Feb 2026, at 3:09=E2=80=AFPM, Paul Durrant <xadimgnik@gmail.com>=
 wrote:
> >>
> >> On 18/02/2026 11:42, Ani Sinha wrote:
> >>> On confidential guests KVM virtual machine file descriptor changes as=
 a
> >>> part of the guest reset process. Xen capabilities needs to be re-init=
ialized in
> >>> KVM against the new file descriptor.
> >>> Signed-off-by: Ani Sinha <anisinha@redhat.com>
> >>> ---
> >>>   target/i386/kvm/xen-emu.c | 50 ++++++++++++++++++++++++++++++++++++=
+--
> >>>   1 file changed, 48 insertions(+), 2 deletions(-)
> >>> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
> >>> index 52de019834..69527145eb 100644
> >>> --- a/target/i386/kvm/xen-emu.c
> >>> +++ b/target/i386/kvm/xen-emu.c
> >>> @@ -44,9 +44,12 @@
> >>>     #include "xen-compat.h"
> >>>   +NotifierWithReturn xen_vmfd_change_notifier;
> >>> +static bool hyperv_enabled;
> >>>   static void xen_vcpu_singleshot_timer_event(void *opaque);
> >>>   static void xen_vcpu_periodic_timer_event(void *opaque);
> >>>   static int vcpuop_stop_singleshot_timer(CPUState *cs);
> >>> +static int do_initialize_xen_caps(KVMState *s, uint32_t hypercall_ms=
r);
> >>>     #ifdef TARGET_X86_64
> >>>   #define hypercall_compat32(longmode) (!(longmode))
> >>> @@ -54,6 +57,30 @@ static int vcpuop_stop_singleshot_timer(CPUState *=
cs);
> >>>   #define hypercall_compat32(longmode) (false)
> >>>   #endif
> >>>   +static int xen_handle_vmfd_change(NotifierWithReturn *n,
> >>> +                                  void *data, Error** errp)
> >>> +{
> >>> +    int ret;
> >>> +
> >>> +    /* we are not interested in pre vmfd change notification */
> >>> +    if (((VmfdChangeNotifier *)data)->pre) {
> >>> +        return 0;
> >>> +    }
> >>> +
> >>> +    ret =3D do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR);
> >>> +    if (ret < 0) {
> >>> +        return ret;
> >>> +    }
> >>> +
> >>> +    if (hyperv_enabled) {
> >>> +        ret =3D do_initialize_xen_caps(kvm_state, XEN_HYPERCALL_MSR_=
HYPERV);
> >>> +        if (ret < 0) {
> >>> +            return ret;
> >>> +        }
> >>> +    }
> >>> +    return 0;
> >>
> >> This seems odd. Why use the hyperv_enabled boolean, rather than simply=
 the msr value, since when hyperv_enabled is set you will be calling do_ini=
tialize_xen_caps() twice.
> >
> > I am not sure of enabling capabilities for Xen. I assumed we need to ca=
ll kvm_xen_init() twice, once normally with XEN_HYPERCALL_MSR and if hyper =
is enabled, again with XEN_HYPERCALL_MSR_HYPERV. Is that not the case? Is i=
t one or the other but not both? It seems kvm_arch_init() calls kvm_xen_ini=
t() once with XEN_HYPERCALL_MSR and another time vcpu_arch_init() calls it =
again if hyperv is enabled with XEN_HYPERCALL_MSR_HYPERV .
>
> Yes, it has to be assumed that XEN_HYPERCALL_MSR is correct until
> Hyper-V supported is enabled, which comes later, at which point the MSR
> is changed. So you only need save the latest MSR value and use that in
> xen_handle_vmfd_change().

ok hopefully this looks good
https://gitlab.com/anisinha/qemu/-/commit/7f7ba25151b6a658c54f95a370f1970c0=
1a6269a

sending this out to minimize churn and to make v6 as close to the
merge worthy as possible.


