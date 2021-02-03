Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB330D613
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbhBCJRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 04:17:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233342AbhBCJRV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 04:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612343755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cJJK3qNERG1luckatuh8Y6BGWPbFjbZumZ5BkOC5HpU=;
        b=QQmaw9b7fHhaoHBGuEVIGM4feU2P0NS6PYeZh5MDRiY472MEZRE1yt7kMlZkErnSwqjITQ
        KBUXygJ8L5z+vCQUT+nucAxs3tneL/I8H/5IKSCND8LYhMc+rktjZlXnT/C8uO41Qo1Pmd
        yc6Ve4wsMZUbe25CeatdpgW6G6z6Dvg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-6NkwhtQcND-_rQvMsA5U3A-1; Wed, 03 Feb 2021 04:15:53 -0500
X-MC-Unique: 6NkwhtQcND-_rQvMsA5U3A-1
Received: by mail-ej1-f72.google.com with SMTP id bx12so4334286ejc.15
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 01:15:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cJJK3qNERG1luckatuh8Y6BGWPbFjbZumZ5BkOC5HpU=;
        b=dWYnlwe/XQBlGwdS7f/GMB7I137M46PspBgxsuN/G+bwjum31UnYioUxe2NwybN3gG
         vvAgwp6iimfD89nlM+OTfhyC/4JbzxAdMVGz5a3si1YEts1VwZibAHjZ5F/rqdBBgc0Y
         hjeZ5tNvoGQhH1Lf+DPGfPpi7Lu89I84eiphV4IX0TGrPI4PT4S/HEEPLvyZKool98SK
         oCe/4hFByIwC3w/teuS5tOUKEcNeRS7CfirVgz3INxHi1fyMTuF/79NLCa2I1+beJBdP
         i23kpEAzwKmmKDb+Cj4U940cKt+NwyobbrtpI0FdTePIqvXH6/X0wmLSQZj3tVDADYi9
         tLgQ==
X-Gm-Message-State: AOAM530mBc7lXJ2U7np9YwcWukSBXOM+j54fHFR61rZ4UYWrI6KG4m7E
        hfF1B3L3eo2kkdgu4NdIjmdM/J1iNcRdgFfvqaBr2X7l70mgxc7IYH4pvqKezxBAALpMmdt5wRs
        9eBSerFIXuxbE
X-Received: by 2002:a05:6402:2029:: with SMTP id ay9mr1938186edb.373.1612343752599;
        Wed, 03 Feb 2021 01:15:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvLXv30MwxASwvybAz0WSIbo63Sp9neFadSuty3raoAfNRSnRLfoYp7EvFM06U1Ux0uQvinw==
X-Received: by 2002:a05:6402:2029:: with SMTP id ay9mr1938174edb.373.1612343752464;
        Wed, 03 Feb 2021 01:15:52 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id w3sm713171eja.52.2021.02.03.01.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 01:15:51 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Kechen Lu <kechenl@nvidia.com>
Cc:     "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Somdutta Roy <somduttar@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-discuss@nongnu.org" <qemu-discuss@nongnu.org>
Subject: Re: Optimized clocksource with AMD AVIC enabled for Windows guest
In-Reply-To: <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
References: <DM6PR12MB3500B7D1EDC5B5B26B6E96FBCAB49@DM6PR12MB3500.namprd12.prod.outlook.com>
 <5688445c-b9c8-dbd6-e9ee-ed40df84f8ca@redhat.com>
Date:   Wed, 03 Feb 2021 10:15:51 +0100
Message-ID: <878s85pl4o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 03/02/21 07:40, Kechen Lu wrote:
>> From the above observations, trying to see if there's a way for
>> enabling AVIC while also having the most optimized clock source for
>> windows guest.
>> 
>
> You would have to change KVM, so that AVIC is only disabled if Auto-EOI 
> interrupts are used.
>

(I vaguely recall having this was discussed already but apparently no
changes were made since)

Hyper-V TLFS defines the following bit:

CPUID 0x40000004.EAX 
Bit 9: Recommend deprecating AutoEOI.

But this is merely a recommendation and older Windows versions may not
know about the bit and still use it. We need to make sure the bit is
set/exposed to Windows guests but we also must track AutoEOI usage and
inhibit AVIC when detected.

-- 
Vitaly

