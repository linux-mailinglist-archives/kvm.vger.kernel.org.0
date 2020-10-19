Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288652927A6
	for <lists+kvm@lfdr.de>; Mon, 19 Oct 2020 14:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgJSMu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Oct 2020 08:50:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726561AbgJSMu4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Oct 2020 08:50:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603111855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VKbXwf4+mcbeKehYI1z20l9UIe1TokmoIfEoo7RIUYo=;
        b=eCx5r2hVLHhwoJp5hAO6LszTN9K4w1Q6eND8ZoVnUWjXWh5EV70BgzIXV1bgMhuW61IkmC
        eWl8JuwJaJQGlXZF1oOwq62NX0KoKoKhwGWswBklCdu5eCYWWbjK8UVq+ax83nPF4j5ymM
        5IFr0y4RAc4R0dmvUC4taVBW6M6dpcg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-pg-QPXe9O928M0Q57V853A-1; Mon, 19 Oct 2020 08:50:53 -0400
X-MC-Unique: pg-QPXe9O928M0Q57V853A-1
Received: by mail-wr1-f69.google.com with SMTP id h8so5481444wrt.9
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 05:50:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VKbXwf4+mcbeKehYI1z20l9UIe1TokmoIfEoo7RIUYo=;
        b=nqto1zkPQMSVgFP8F1e6oe6U2RTQDDMVDf2XIscYdzCpLYphAVsUwBr9+/c0/CUhIp
         8ILdBHWl4jJstsDW1q5+xzRmNS7miECEjaeRG4m7xzlfRLI0FfHat/hoIveJg3ycPHkn
         sdNj9SIWCiW0l9QLfD/Vurdsdpyno+31BgshV2Egn0IGyLtzAj+8o2HKkUGiykMWyMx4
         8bClAIt1egmSueeVqCX8YLi8FzHt/+WXkO3j6IeIyR7sQYdZRro58LgxBZh8SZdQeMAW
         UFO7E9qgMBUgYUT7SPo7LrnjZP4M8pRo5PY5M7v+TbyiRhApaMvcpgrTcmoKMtQU0Nn2
         vzVQ==
X-Gm-Message-State: AOAM532fKD+50LOKo7svoG7JBdBdwn4QZv+VzkKqIeDd95PdxTa6XkBd
        jgibkamkdWjOj9BEVv75piydGEIobJxcedGEhLMBYP7YWofZse/u+gHqaQ8qkBhAng3yvgqCf12
        hAzloYP4FhgYs
X-Received: by 2002:a7b:c418:: with SMTP id k24mr18278498wmi.118.1603111851931;
        Mon, 19 Oct 2020 05:50:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7IguPe7eZw+dfDTAsx9GR0C6WN6hqOxMvMsojTsn/pWrzXldNJif3UL4sbamz6brVCIw++Q==
X-Received: by 2002:a7b:c418:: with SMTP id k24mr18278482wmi.118.1603111851728;
        Mon, 19 Oct 2020 05:50:51 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id l26sm15944178wmi.39.2020.10.19.05.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 05:50:50 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Haiwei Li <lihaiwei.kernel@gmail.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        Haiwei Li <lihaiwei@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] KVM: Check the allocation of pv cpu mask
In-Reply-To: <0330c9df-7ede-815b-0e6e-10fb883eda35@gmail.com>
References: <20201017175436.17116-1-lihaiwei.kernel@gmail.com> <87r1pu4fxv.fsf@vitty.brq.redhat.com> <0330c9df-7ede-815b-0e6e-10fb883eda35@gmail.com>
Date:   Mon, 19 Oct 2020 14:50:49 +0200
Message-ID: <87imb64bx2.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Haiwei Li <lihaiwei.kernel@gmail.com> writes:

> And 'pv_ops.mmu.tlb_remove_table = tlb_remove_table' should not 
> be set either.

AFAIU by looking at the commit which added it (48a8b97cfd80 "x86/mm:
Only use tlb_remove_table() for paravirt") it sholdn't hurt much. We
could've avoided the assignment but it happens much earlier, in
kvm_guest_init() and there's no good way to un-patch pvops back.

-- 
Vitaly

