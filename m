Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5DB397CF7
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 01:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhFAXVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 19:21:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53094 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234766AbhFAXVq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Jun 2021 19:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622589603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GxsHHoTk80ra37uWURN30H/nOhBanmqVqpOS4/rL0zo=;
        b=XKBG0sOf6zzLafEIBxUwucanlGXWUuriDvh6+jFbKitIX9zTtdkdemvl3breRE2vGLQ+Cd
        jFFWpmHhhKvTTIY2lkd2QQn2BKarNt3SeQbNp8DIfrYKzxB3+1pdtBS/ldWflqS9JZ+fj3
        RWvr5lz7ct+mwUrAHXotzI8BmT9L90c=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-qwMogrWGOhqgrRd9CZPPLQ-1; Tue, 01 Jun 2021 19:20:02 -0400
X-MC-Unique: qwMogrWGOhqgrRd9CZPPLQ-1
Received: by mail-qt1-f200.google.com with SMTP id a12-20020ac8108c0000b029023c90fba3dcso338583qtj.7
        for <kvm@vger.kernel.org>; Tue, 01 Jun 2021 16:20:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxsHHoTk80ra37uWURN30H/nOhBanmqVqpOS4/rL0zo=;
        b=dm88qa0S9lcspZ8YKPBFSH76WXcbbbMQg1bg8vsclRSxlvwE9tnDqdp0fkRDQXOJsE
         ZivtHPMY9RhpdUbuHHi5rzpowIcXwrQpn9QQ6vQ8hryekI4t8l4jKX7symuMaOAFa4gZ
         +a0kqbd8HGq4cZIBNeb3wXgx8VK/R0kv7wraHExjsM6clyrHFZFDdkS48nPgCGrK+Lz+
         7tYrLINtVZnmFkBvCHpTxZUXvudaQ/UcMifPK0QGOugJKyKg3Uzo/PD1jy5TDcunL7UY
         4IeGMKivPRUUQv19EraMRBRKzI/7MLPnZw6jaQQ6T2nkETyuUfDbtHn4LQVmqMoxDFF6
         FDww==
X-Gm-Message-State: AOAM5305OwLDIBaWKcFu5MtRH4/3tjuV+mtPOr9wwla3Wq9EwPfkHa/F
        iE3Adtj5wrvyeknkST0AcIi5nWpRzMEVuEb78AQyeZhIDUv0Cj9nuk4pgY+9tUHAjn2Z+rpgYjH
        VnKfTxULYD4Zu
X-Received: by 2002:a37:6f05:: with SMTP id k5mr18097458qkc.313.1622589602140;
        Tue, 01 Jun 2021 16:20:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx85uMM/8lal6FIJBvU/Vwx7SFNkcGoQadjr8btCxPa6PjVNzBqxzT6QDoAgGUEfi/DQRYuSA==
X-Received: by 2002:a37:6f05:: with SMTP id k5mr18097442qkc.313.1622589601924;
        Tue, 01 Jun 2021 16:20:01 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-61-184-147-118-108.dsl.bell.ca. [184.147.118.108])
        by smtp.gmail.com with ESMTPSA id a23sm12138420qkl.6.2021.06.01.16.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 16:20:01 -0700 (PDT)
Date:   Tue, 1 Jun 2021 19:20:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     huangy81@chinatelecom.cn
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v1 2/6] KVM: introduce dirty_pages into CPUState
Message-ID: <YLbAoEWOE+no+a7H@t490s>
References: <cover.1622479161.git.huangy81@chinatelecom.cn>
 <78cc154863754a93d88070d1fae9fed6a1ec5f01.1622479161.git.huangy81@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78cc154863754a93d88070d1fae9fed6a1ec5f01.1622479161.git.huangy81@chinatelecom.cn>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021 at 01:04:06AM +0800, huangy81@chinatelecom.cn wrote:
> diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
> index 044f668a6e..973c193501 100644
> --- a/include/hw/core/cpu.h
> +++ b/include/hw/core/cpu.h
> @@ -375,6 +375,8 @@ struct CPUState {
>      struct kvm_run *kvm_run;
>      struct kvm_dirty_gfn *kvm_dirty_gfns;
>      uint32_t kvm_fetch_index;
> +    uint64_t dirty_pages;
> +    bool stat_dirty_pages;

Shall we make this bool a global one?  As I don't think we'll be able to only
enable it on a subset of cpus?

-- 
Peter Xu

