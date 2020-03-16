Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37798186F36
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 16:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbgCPPvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 11:51:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:50761 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732058AbgCPPvF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 16 Mar 2020 11:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584373864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fUuCYueA3lMuDwdeZICwCc8xpvqxEIl0C/2eLY4HFss=;
        b=VQs1LV8UQt4mqJs2Ff+lpyxud4KmVWxiJtLx0tWgWBs0e8TwkrztCWo5qp355ly65f3Y0b
        XFwX4eSuf8cK9/681YPalr2e8S4QH3/I+auL4VqyKWqqt7IfvL4smi52SJzl4Dy504mBqr
        TAwCdYxDb1l2m8YiwnawMgX8jFLyHKg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-mvdqYcp4M3C4gKvHgVLI3w-1; Mon, 16 Mar 2020 11:44:50 -0400
X-MC-Unique: mvdqYcp4M3C4gKvHgVLI3w-1
Received: by mail-wm1-f70.google.com with SMTP id a23so5964409wmm.8
        for <kvm@vger.kernel.org>; Mon, 16 Mar 2020 08:44:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fUuCYueA3lMuDwdeZICwCc8xpvqxEIl0C/2eLY4HFss=;
        b=ksBRLzaJ7EKmZ3Qtc0V0zY/Pi/7wzfNqt9y/fKih1JAX6QQtblVAhWBD35nLZOBa5c
         yODL4ur2Mgh2b7uaPGAqh3pxYgBtV9tU515nDwg3/X+NO2fUT7HIT69oUwFN+rCNX3em
         x75Y7OVVIZlVP8aQaCBLbPY4baCJMs3hZVCpVFOWUvJaaX1IjFjieUoI738hm5nraDe3
         1qW3vPlVk1bIFc6Tj9smLPlLZTTmX2HyM8pS52dE+UMyBwAcYSQBJ4a/Q3hoI8RDeZ55
         cW6T7LPfsU9IJcy7/WwALnjj6ZyR7KFtvF8/EhPku/ZFYa65QWsRzd0T81rXHq91TOvK
         IMWA==
X-Gm-Message-State: ANhLgQ1U61o/WaNfBh9WIGXHoD3tj872tu8LQfnpP8hnHPZW5jiXhDRj
        lqIXPXLoPAOcKHML2JzRup6R+o86ql2sbJfAce/35k/+D6cbH+HZHu4u6wu/jejyAaFRUMvDACm
        oPSwv4rvOsN66
X-Received: by 2002:a1c:e442:: with SMTP id b63mr29201210wmh.174.1584373489103;
        Mon, 16 Mar 2020 08:44:49 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsm0twtuBMCOFO0oksSJxj4VZxA6HrZ3ItbOIShmzBDz85OEDCbgoiXWzoQkLGleoeOgMTbZA==
X-Received: by 2002:a1c:e442:: with SMTP id b63mr29201190wmh.174.1584373488897;
        Mon, 16 Mar 2020 08:44:48 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id 98sm412922wrk.52.2020.03.16.08.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:44:48 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linmiaohe@huawei.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: correct meaningless kvm_apicv_activated() check
In-Reply-To: <20200316152650.GD24267@linux.intel.com>
References: <1584185480-3556-1-git-send-email-pbonzini@redhat.com> <878sk0n1g1.fsf@vitty.brq.redhat.com> <20200316152650.GD24267@linux.intel.com>
Date:   Mon, 16 Mar 2020 16:44:47 +0100
Message-ID: <87zhcgl2xc.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Mon, Mar 16, 2020 at 09:33:50AM +0100, Vitaly Kuznetsov wrote:
>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> > +	if ((old == 0) == (new == 0))
>> > +		return;
>> 
>> This is a very laconic expression I personally find hard to read :-)
>> 
>> 	/* Check if WE actually changed APICv state */
>>         if ((!old && !new) || (old && new))
>> 		return;
>> 
>> would be my preference (not strong though, I read yours several times
>> and now I feel like I understand it just fine :-)
>
> Or maybe this to avoid so many equals signs?
>
> 	if (!old == !new)
> 		return;
>

	if (!!old == !!new)
		return;

to make it clear we're converting them to 1/0 :-)

-- 
Vitaly

