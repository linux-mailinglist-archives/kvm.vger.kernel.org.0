Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 647022BAF0E
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 16:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgKTPds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 10:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgKTPds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 10:33:48 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D884BC0613CF;
        Fri, 20 Nov 2020 07:33:47 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id t9so9939176edq.8;
        Fri, 20 Nov 2020 07:33:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hu7c85Nnad/NCLFvwvmPMVk5vXB6RmH3f8h9eUOgl90=;
        b=BzmaIsz1H6BVAIbAH9IvLryH4vb8O/6UhSCRnp06XFQRDmxv8tRES8boF0UNRfcvJa
         FOQYceZ7HDFXHFQt5NrioQms4xLE57+3p5wE8nI+1qbLkHTEjG4ILQgPTJWQSryLN+vP
         Y7p77Sp5LGtKgdkXehar1Xf7r6Oxn40NWIGwTXFu4MREQ/+EBEZlXO6IKlRBR8u2NFct
         hfqT1x/qHOUJOp7jOZ28M/5kQ5lHwKvKlPEqugKopuo3E9Ea29B+MHZa9k5/bzlFuZw4
         cpV4WZ45p3JYrZOyq1l3kvJzajpgqZj+rHeJ+LT3hADUtWTfh021alrkCxAb6xX7zsAw
         XUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hu7c85Nnad/NCLFvwvmPMVk5vXB6RmH3f8h9eUOgl90=;
        b=GiZkcNZGd630zV3zKvIVqKsDuOKGmprMqkYdOZ9w1dB6oCBWW/tYnJ0Sw+EUnElWQf
         x9A3IQCBJMzaebkOE5QSqf4gH/+FHJKyK4dSo8I5AAsOM7gXk551BCCPUidGtzt1jpRG
         8yl6Iwl4yVMMHOk2iVmxubowUPVLtIf2QjjkZAlmDLn0CBt/GLkLvnqHDAaIA0CJ2yHv
         HXNC1y/NtroG02vynzw00QS7zLQbfIb5ua0ZD6+/vBTUTTVdedVR8qV9g4g0HNEduxcr
         7spRKsbrCx7OdnUtAOzuZV277HNkLjKXL/GAPtkVhX1UDFDV7sn84p++YSZ/acUu7SSw
         yTmA==
X-Gm-Message-State: AOAM530XHt7iecAA/4i9kYG4Dae2ybNmpSCLJZtr8zHCbjOpsvKwBDIr
        hq95de90VK1oceoSjAnJY4U=
X-Google-Smtp-Source: ABdhPJw731OYdrhHa2qWzQq4JOlXbH+fA7iL3hkHPnFGLmtrlwCQKxKF56MlTknU1rfyVnD6hVXqLg==
X-Received: by 2002:a50:e443:: with SMTP id e3mr37089342edm.160.1605886426571;
        Fri, 20 Nov 2020 07:33:46 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id a10sm1235482edn.77.2020.11.20.07.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 07:33:45 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH v6 16/17] RFC: kvm: pass kvm argument to follow_pfn
 callsites
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
References: <20201119144146.1045202-1-daniel.vetter@ffwll.ch>
 <20201119144146.1045202-17-daniel.vetter@ffwll.ch>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cd56eb8a-fbec-e81f-9c14-d1256a193b68@redhat.com>
Date:   Fri, 20 Nov 2020 16:33:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201119144146.1045202-17-daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/20 15:41, Daniel Vetter wrote:
> Both Christoph Hellwig and Jason Gunthorpe suggested that usage of
> follow_pfn by modules should be locked down more. To do so callers
> need to be able to pass the mmu_notifier subscription corresponding
> to the mm_struct to follow_pfn().
> 
> This patch does the rote work of doing that in the kvm subsystem. In
> most places this is solved by passing struct kvm * down the call
> stacks as an additional parameter, since that contains the
> mmu_notifier.
> 
> Compile tested on all affected arch.

It's a bit of a pity, it's making an API more complex (the point of 
gfn_to_pfn_memslot vs gfn_to_pfn is exactly that you don't need a 
"struct kvm*" and it's clear that you've already done the lookup into 
that struct kvm.

But it's not a big deal, and the rationale at least makes sense.  So,

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
