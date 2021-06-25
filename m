Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2E3B4685
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFYPZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 11:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhFYPZD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 11:25:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624634562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c60/pv7sL8eCu7tXeJN0+FKp9/E4tHFjAmIjYk7Ari4=;
        b=DBPr2AGhLcP2BXteJb4AmEsJZ7/UmGb1h14cZgL9a319HnVwZPKnpxSlcbc3/upAwBVlaJ
        CyShjY8lDpH+mHJICy72mQ5qW0RVlVtCmenLFNy9zq5G1iS0FA//DtdRaGIW/dkF8F+VbX
        TbcPVeKo2v2LWhSnHdZfbs2LiuHKGP4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-220-Tj_UDvOMMwSF23rjAdBkdA-1; Fri, 25 Jun 2021 11:22:40 -0400
X-MC-Unique: Tj_UDvOMMwSF23rjAdBkdA-1
Received: by mail-wm1-f72.google.com with SMTP id j6-20020a05600c1906b029019e9c982271so4342273wmq.0
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 08:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c60/pv7sL8eCu7tXeJN0+FKp9/E4tHFjAmIjYk7Ari4=;
        b=clavNUFzKzFXwKMJfIufv2FtDn+gg/Cp5mYJNpjfZbI/yuH67Wby/R2i7snaDfBdoG
         jHz0fOtfCoZTE59TqCuvtFQgn1qhinSRWk/RA46wXpYh6pm2ZDJph1TbCnLShzThISL8
         KAK+HrUTuP/rC7wA0d87/ZtY39fwx1K858aNnLuYYbPMXhaYkmXgwWVhZ9L5i5Ljh+Mr
         NnF3Jz9XwIP9pwHreTqRSVn8q5wcL+4crcpnUQZ4uo89pRygQaQQdsvB0p7f8HFGOr0l
         vn7SQvLBohVLUMSjewRoU2adiCmlXtNMXIqzxpGRg85Pb4Ntz5U/cOxxBRD4TYmYfxRw
         47Ew==
X-Gm-Message-State: AOAM531GVWVK7I/TKhRxqVz9RJWSlxXx9IJpvyRL9CjefGuZDlGSr0Va
        glZKj7PdTrKBac4KtCetOhWrAZtQ954lqtcjDvmuxRUijUF+2wq/XLdwi9ySrtMrR8StmH4MWBb
        EgVBBwyaQ4tTl
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr11400154wrs.43.1624634559689;
        Fri, 25 Jun 2021 08:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDGD9t/H/HRws3awcg3HRn/cf6d23iY7tTVM5TXBjLc44hX2J/pwawWcJJd8s4t+aHlLMlDA==
X-Received: by 2002:a5d:45cc:: with SMTP id b12mr11400130wrs.43.1624634559537;
        Fri, 25 Jun 2021 08:22:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y7sm11207948wma.22.2021.06.25.08.22.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 08:22:38 -0700 (PDT)
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba <tabba@google.com>, Jinank Jain <jinankj@amazon.de>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20210625134357.12804-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.14
Message-ID: <a302cb0c-dc44-8acf-93b9-0048c757f82e@redhat.com>
Date:   Fri, 25 Jun 2021 17:22:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210625134357.12804-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/21 15:43, Marc Zyngier wrote:
> - Add MTE support in guests, complete with tag save/restore interface
> - Reduce the impact of CMOs by moving them in the page-table code
> - Allow device block mappings at stage-2
> - Reduce the footprint of the vmemmap in protected mode
> - Support the vGIC on dumb systems such as the Apple M1
> - Add selftest infrastructure to support multiple configuration
>    and apply that to PMU/non-PMU setups
> - Add selftests for the debug architecture
> - The usual crop of PMU fixes

Oh well since all the arches are here let's just send a single pull request.

> Note that we carry a branch (arm64/for-next/caches) shared with the
> arm64 tree in order to avoid ugly conflicts. You will still get a few
> minor ones with the PPC tree, but the resolution is obvious.

Great, thanks.

> Oh, and each merge commit has a full description of what they contain.
> Hopefully we won't get yelled at this time.

Heh, I probably should have yelled at you last time too. :)  But this 
time it's all looking really good to me too!

Paolo

