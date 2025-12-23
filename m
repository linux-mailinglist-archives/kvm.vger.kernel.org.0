Return-Path: <kvm+bounces-66607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3285ACD865B
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 08:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67B8230155D8
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 07:39:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5A02FDC2C;
	Tue, 23 Dec 2025 07:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PikjKbsA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OmMZcoPC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A323D7DC
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 07:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766475545; cv=none; b=S2I52POxWxoqzEpgnrD3jkOYso9mcYTsuPbojoUofsty9C9p8SCU8IMAn6Lv+UIZTiEdi4e6AabvOkzXPxHXHjrl0iBOH4DI4WklDomyD9aVZgC4pcmADfxMLCHOrtXgPdj4h2cbqWr83F5omZxSjlQjHI1Jk56b5bY71tUUkQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766475545; c=relaxed/simple;
	bh=i+BVAhZGiT/7ZDJ1B75OzIZWENLqYn4rEdekJD2Z4FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gdLgA4+1pFCKKOEtWlKDY1fiBU/+70aDm91GfEs/K1I+N4NgwsvGtqfvHTCDgxuG4ReLDrHKx0J0B8gls/Gp/pEkWV90e0PgtssS06x19jQyakWY8+JbehKfZ5V94JTM3vp9k3LparawIWqQHaFCarvmjiyL/Db4V3IzsRx+9vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PikjKbsA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OmMZcoPC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766475542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lMvmTHI5paTvBwu2ZZukpEJvGw0i5hbjEF/R4f1x9m0=;
	b=PikjKbsA9iapVh6axsF93qG9gBbs1zTWX6KGmat1V0xMYOrNBmZyDPdKQkYNEH2fTFwCKP
	44aOfO7Cy4DoEoUH30OJBEKtJ/IAg8+pVHyCVTSW9PP+0mbKTIQMiHJtVjk9AUG1K509HL
	nznvp4vm8I1xOUMDlIwyMijFjlwRS2k=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-FCs5qXWONdK0bAp_IB6lIA-1; Tue, 23 Dec 2025 02:39:01 -0500
X-MC-Unique: FCs5qXWONdK0bAp_IB6lIA-1
X-Mimecast-MFC-AGG-ID: FCs5qXWONdK0bAp_IB6lIA_1766475540
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so9902828a91.1
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 23:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766475540; x=1767080340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMvmTHI5paTvBwu2ZZukpEJvGw0i5hbjEF/R4f1x9m0=;
        b=OmMZcoPCltLK/kv5yCdocQ9OGYbaa8uUP6AXQFVB9W8kXEQdj09Sm+EzXoKrk9IC75
         zx4Zr8JnuZast1GzUznhvEYyFkyHuUjeatbBmL2UsZg5u3wlrGDwodcIdDMWG8CRkQgv
         38S7vcF1gSpYOuRxLdptrMZRIdHoWSnupjNAfCbU3hg4uD5VkTN8bjRfTkh4F9H9UlS4
         NutJqq//Lw38b555rYZ/2IMdkZmMaTrBrfFn5LGJQgqGtyiTmuTIQLze0RLQhkbfVFq+
         SYGu3LNDkGOpZXFRsd+I4jgNilQXEk722htp3gH7rzNibp9JTqZ17vFkMfrJA/8UPSHE
         8/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766475540; x=1767080340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lMvmTHI5paTvBwu2ZZukpEJvGw0i5hbjEF/R4f1x9m0=;
        b=Zp5kHffkFiH+oV863pOGE/o07UvRh9g8+IwQBSx3bgMtVUNzou3/dXjEomCS9Qnoxp
         oGlUrhVH9P7bf4Q09IvRIh9zBW+o+Zw0ZB5kSAWGiYcmPi8NeKoWF/r9rVRr6bZ85ktW
         /Yebr7msjZ9oQOyRyxTs9ywV+gDqvmoA/oS0cQRca/YrnIPBw+VnbzDIUBTyymtEmQBx
         obycmxmPRCQABTqwB12wQiNEktvjW8ndMkxY+RxDSY/yZKfmjz9RESK4JwdXgSLBsJEi
         okD5wFcYKBQdHed9PDAc9umWzwt81qHwEdbRsEu5F9IxGbUAtLg2lo2qyTtaYnZtuT9i
         Pb/w==
X-Forwarded-Encrypted: i=1; AJvYcCXcft8i8HoxJMQkE/funQ/+EaAiHKp9NiRCSQNJEBVRsxSTovcJwmIiu67MbLfRrp82HuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL+CCUp7EsKpXEhEt264d0q8lWl0wfoNBI9KpxTrcz3qXvmc9T
	2Ar12+qkF1XXq/0NrkGVr1lICnhhILJA4GENbSUZZr7rvuCo1CiJwW/KabszKXb5EoS3KLsFBIp
	kRtPDLz+t5wzKZ0nzbdyOdA6yZEjXE8+LWtc2sdljX0MAMQqwekH3Sw==
X-Gm-Gg: AY/fxX4r9pR0EleN5FGhroTjmiHBD4bHoUMvu3ZfvMVdgK2Am7P9iYBuCtJdT2UEPAU
	WmAd0d1T2iZ+6g26DE8h8wf+XUK27Q9CWO8BuH4J0YgBxFotbEcR+A5CLEYfeNr/S7u+9YUrVAj
	VPak3Sl/OZn7G32VWaWQWRBk/zr+PMGpxG1KJWeZQqKcNUVQTG9PIiQfv19j0igY7AIi/Qzd0LK
	f2T05sw/C31PEsGj1KFwXXYomxWE+QvgZ6aeEYO/j8JcBkTtrK7GwwCtnyivX6P2mmSXrtItpgi
	jrjo/OT8J1U+BaVg4WBZInUwGd6JceMwBJZ60ra0UrmY8I26TcEzhnU+ZeYSry5nqvx6k2zZ8G0
	tAv0i
X-Received: by 2002:a17:90b:54c4:b0:340:e4fb:130b with SMTP id 98e67ed59e1d1-34e92142b7emr12116868a91.14.1766475539824;
        Mon, 22 Dec 2025 23:38:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFIiUtO8P5Tzf6BU+ot5Qp1NQrys4aporgrd5ou8kqAzZxprzN/VX+AhYMOUlrGdNv3hkrAQA==
X-Received: by 2002:a17:90b:54c4:b0:340:e4fb:130b with SMTP id 98e67ed59e1d1-34e92142b7emr12116854a91.14.1766475539432;
        Mon, 22 Dec 2025 23:38:59 -0800 (PST)
Received: from zeus ([2405:6580:83a0:7600:6e93:a15a:9134:ae1f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e769c114bsm7607934a91.0.2025.12.22.23.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 23:38:58 -0800 (PST)
Date: Tue, 23 Dec 2025 16:38:55 +0900
From: Ryosuke Yasuoka <ryasuoka@redhat.com>
To: pbonzini@redhat.com, vkuznets@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/kvm: Avoid freeing stack-allocated node in
 kvm_async_pf_queue_task
Message-ID: <aUpHD8vC-3k_osYj@zeus>
References: <20251206140939.144038-1-ryasuoka@redhat.com>
 <875xae4ehl.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875xae4ehl.fsf@redhat.com>

On Wed, Dec 10, 2025 at 03:07:34PM +0100, Vitaly Kuznetsov wrote:
> Ryosuke Yasuoka <ryasuoka@redhat.com> writes:
> 
> > kvm_async_pf_queue_task() can incorrectly try to kfree() a node
> > allocated on the stack of kvm_async_pf_task_wait_schedule().
> >
> > This occurs when a task requests a PF while another task's PF request
> > with the same token is still pending. Since the token is derived from
> > the (u32)address in exc_page_fault(), two different tasks can generate
> > the same token.
> >
> > Currently, kvm_async_pf_queue_task() assumes that any entry found in the
> > list is a dummy entry and tries to kfree() it. To fix this, add a flag
> > to the node structure to distinguish stack-allocated nodes, and only
> > kfree() the node if it is a dummy entry.
> >
> > Signed-off-by: Ryosuke Yasuoka <ryasuoka@redhat.com>
> > ---
> >
> > v2:
> > Based on Vitaly's comment,
> > * Update comment in kvm_async_pf_queue_task
> > * Set n->dummy false in kvm_async_pf_queue_task
> > * Add explanation about what token is in commit message.
> >
> > v1:
> > https://lore.kernel.org/all/87cy4vlmv8.fsf@redhat.com/
> >
> >
> >  arch/x86/kernel/kvm.c | 19 ++++++++++++++++---
> >  1 file changed, 16 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index df78ddee0abb..37dc8465e0f5 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -89,6 +89,7 @@ struct kvm_task_sleep_node {
> >  	struct swait_queue_head wq;
> >  	u32 token;
> >  	int cpu;
> > +	bool dummy;
> >  };
> >  
> >  static struct kvm_task_sleep_head {
> > @@ -120,15 +121,26 @@ static bool kvm_async_pf_queue_task(u32 token, struct kvm_task_sleep_node *n)
> >  	raw_spin_lock(&b->lock);
> >  	e = _find_apf_task(b, token);
> >  	if (e) {
> > -		/* dummy entry exist -> wake up was delivered ahead of PF */
> > -		hlist_del(&e->link);
> > +		struct kvm_task_sleep_node *dummy = NULL;
> > +
> > +		/*
> > +		 * The entry can either be a 'dummy' entry (which is put on the
> > +		 * list when wake-up happens ahead of APF handling completion)
> > +		 * or a token from another task which should not be touched.
> > +		 */
> > +		if (e->dummy) {
> > +			hlist_del(&e->link);
> > +			dummy = e;
> > +		}
> > +
> >  		raw_spin_unlock(&b->lock);
> > -		kfree(e);
> > +		kfree(dummy);
> >  		return false;
> >  	}
> >  
> >  	n->token = token;
> >  	n->cpu = smp_processor_id();
> > +	n->dummy = false;
> >  	init_swait_queue_head(&n->wq);
> >  	hlist_add_head(&n->link, &b->list);
> >  	raw_spin_unlock(&b->lock);
> > @@ -231,6 +243,7 @@ static void kvm_async_pf_task_wake(u32 token)
> >  		}
> >  		dummy->token = token;
> >  		dummy->cpu = smp_processor_id();
> > +		dummy->dummy = true;
> >  		init_swait_queue_head(&dummy->wq);
> >  		hlist_add_head(&dummy->link, &b->list);
> >  		dummy = NULL;
> >
> > base-commit: 416f99c3b16f582a3fc6d64a1f77f39d94b76de5
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly

Vitaly,

Thank you for your review.

Hi Paolo,

Just a gentle reminder regarding this patch. It has received a
Reviewed-by tag from Vitaly.

Since this patch fixes a bug encountered by our customers, we would
appreciate it if you could consider applying it.

Let me know if there is anything else needed on my end!

Regards,
Ryosuke


