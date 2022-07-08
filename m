Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F8B56BD70
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238151AbiGHP6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbiGHP6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:58:43 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C0C6B24D
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:58:41 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e132so22700972pgc.5
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8w4bwYuqV6DXk3ShmGJ/aTll0ynf+VvQDcahL2hqj4=;
        b=bfCBNAPgf5AtCFBnWe/2nrt7kg29z/w5Q01kuQ6lA+gveTZTp/emDFQxX4//qULTB1
         /cK4O+t1Z+i0p4mGAfgY8TN8v0tQ0RSvxquGKJmX4QGik5uArQ6ecp3U65ZSDt8cnezy
         vGAyYDn3mUw1c2vTleiOPAnO9QfnpJOoCWVDhAsvcFJI8Rk2RlC4oZQdtEHG3DzFVxZP
         R7aHe9QHxnyRN9lRq7Va+0rjvw5ejyajU+vbEeLjLx7KjBkbz3wGUd+8NPfsVNnERiK3
         WjZgiDfSHkSo40HlMmmR7c5mwZVjIi/thPN0pGgF4588q13cCYCzUgZ6bUJtMN5IYvkD
         57Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B8w4bwYuqV6DXk3ShmGJ/aTll0ynf+VvQDcahL2hqj4=;
        b=2Ly1CeMAvb9VEjzQmauzegnb9VWDLgOmJX6pRaNV7a1zKc1hnJOAmu0CZ5fTUKaIw/
         yjK3gGU9GAKczwHTOJMINmet6R6P0r+VViAOGqitDi938zoYme3ZOgXq+o0VVXffOGH/
         Kt06GEue7GGcPcFlweFEHZXuhdv0CDauqbMvICx9aoj6j5lXeXDQk16kNZ6IUl0NpLix
         IDhs1EUeI+QxfIcxVWyHOd9Gb56V+xZNwp/8chhCOGPEirX6efO1HrOcFDA9ENzXgrHH
         zkoqNbH6oiVPAUVcdgrAgvf1zavCsIG6jZ/XxSgzLtW1yPsPoDHW2KEN7m6GZQduwiLo
         16mA==
X-Gm-Message-State: AJIora8ATvx4LVDHfn9C+zDuFBKsmJ73D+5mZrFvO6kdB8wRjdALv6PG
        rkfNwb6HAfE32lyufy6G+5BF3tQGgCZxmw==
X-Google-Smtp-Source: AGRyM1vTv4xL2/UTTju5PFq9Kvb5or53YEm+WZJ52+HPaHJtWg1ukrZVjJdpIkPwNcaRQPI2DCWFkQ==
X-Received: by 2002:a05:6a00:188e:b0:52a:b545:559f with SMTP id x14-20020a056a00188e00b0052ab545559fmr1935105pfh.18.1657295920505;
        Fri, 08 Jul 2022 08:58:40 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id w23-20020a1709026f1700b00161ccdc172dsm30065208plk.300.2022.07.08.08.58.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 08:58:40 -0700 (PDT)
Date:   Fri, 8 Jul 2022 15:58:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Fully initialize 'struct kvm_lapic_irq' in
 kvm_pv_kick_cpu_op()
Message-ID: <YshULK9IG9mw7ms3@google.com>
References: <20220708125147.593975-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708125147.593975-1-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022, Vitaly Kuznetsov wrote:
> 'vector' and 'trig_mode' fields of 'struct kvm_lapic_irq' are left
> uninitialized in kvm_pv_kick_cpu_op(). While these fields are normally
> not needed for APIC_DM_REMRD, they're still referenced by
> __apic_accept_irq() for trace_kvm_apic_accept_irq(). Fully initialize
> the structure to avoid consuming random stack memory.
> 
> Fixes: a183b638b61c ("KVM: x86: make apic_accept_irq tracepoint more generic")
> Reported-by: syzbot+d6caa905917d353f0d07@syzkaller.appspotmail.com
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
