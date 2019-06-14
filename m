Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5F456F6
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfFNIGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 04:06:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53206 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfFNIGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 04:06:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id s3so1328609wms.2
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 01:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=brjrLWL4JqGzja9isRfXWMtKybZ6QGrjuL4EguZLxds=;
        b=iMSlQDWsKJUJPJF1SreQOeuVxa1XfBceSUfwYP62OSu7VfGGWr8WrZTccKfpqb4RAc
         qVxwYaMth7qVNerGLZHrRBmH5wGPyt2KNtln4En3jy5D+U/uQ0rueix4+bnFfNwYLnvz
         m7SI4zxk4kHL3kEyxqM/8kNDNLgNc8IOthwJ5l+mT0TrMazk5kR1/3xtTTruL3krQABf
         hTqRlxGMDnHJtLezh97hqkPxWFeqOPhNCyDx2E0RPXxo9ocW1cDckwkIaq9EVFmTQIWm
         4eOvgsO0LApWxtFbRjJPCaL/9S0qPn9rgoMMHWUJXICgVfP7G/2YUdJ+DT+CoBnu8Akk
         qHyg==
X-Gm-Message-State: APjAAAXwn8GaFPken9dttkp7QmlpHPnwujg9DTbMM5nqOuAPcOlVTK7J
        ZiO+CJKdOGud85zX74UhHMsriw==
X-Google-Smtp-Source: APXvYqwHJDyTaSrq4WgrXVTA7Ep8ta1CbNp62od8lhVoOZy25e7JaJ95qKwKmYFkG2m/gFo3I4gJSg==
X-Received: by 2002:a1c:7d4e:: with SMTP id y75mr6838905wmc.169.1560499605862;
        Fri, 14 Jun 2019 01:06:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x8sm3073690wmc.5.2019.06.14.01.06.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:06:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dmitry Safonov <dima@arista.com>, linux-kernel@vger.kernel.org,
        Prasanna Panchamukhi <panchamukhi@arista.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Cathy Avery <cavery@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        "Michael Kelley \(EOSG\)" <Michael.H.Kelley@microsoft.com>,
        Mohammed Gamal <mmorsy@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>,
        Sasha Levin <sashal@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        devel@linuxdriverproject.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86/hyperv: Disable preemption while setting reenlightenment vector
In-Reply-To: <alpine.DEB.2.21.1906132059020.1791@nanos.tec.linutronix.de>
References: <20190611212003.26382-1-dima@arista.com> <8736kff6q3.fsf@vitty.brq.redhat.com> <alpine.DEB.2.21.1906132059020.1791@nanos.tec.linutronix.de>
Date:   Fri, 14 Jun 2019 10:06:43 +0200
Message-ID: <87a7ek7fqk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Wed, 12 Jun 2019, Vitaly Kuznetsov wrote:
>> Dmitry Safonov <dima@arista.com> writes:
>> > diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
>> > index 1608050e9df9..0bdd79ecbff8 100644
>> > --- a/arch/x86/hyperv/hv_init.c
>> > +++ b/arch/x86/hyperv/hv_init.c
>> > @@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hv_max_vp_index);
>> >  static int hv_cpu_init(unsigned int cpu)
>> >  {
>> >  	u64 msr_vp_index;
>> > -	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[smp_processor_id()];
>> > +	struct hv_vp_assist_page **hvp = &hv_vp_assist_page[cpu];
>> >  	void **input_arg;
>> >  	struct page *pg;
>> >  
>> > @@ -103,7 +103,7 @@ static int hv_cpu_init(unsigned int cpu)
>> >  
>> >  	hv_get_vp_index(msr_vp_index);
>> >  
>> > -	hv_vp_index[smp_processor_id()] = msr_vp_index;
>> > +	hv_vp_index[cpu] = msr_vp_index;
>> >  
>> >  	if (msr_vp_index > hv_max_vp_index)
>> >  		hv_max_vp_index = msr_vp_index;
>> 
>> The above is unrelated cleanup (as cpu == smp_processor_id() for
>> CPUHP_AP_ONLINE_DYN callbacks), right? As I'm pretty sure these can'd be
>> preempted.
>
> They can be preempted, but they are guaranteed to run on the upcoming CPU,
> i.e. smp_processor_id() is allowed even in preemptible context as the task
> cannot migrate.
>

Ah, right, thanks! The guarantee that they don't migrate should be enough.

-- 
Vitaly
