Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D43740A5F
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbjF1IDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:03:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231483AbjF1IBA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jun 2023 04:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687939210;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gEFCO6LP8mfvqL0i/v3L1hgRp+ixmHtRy0L/FBujzDA=;
        b=dD5zZ91XYdEbkWmP4OmMLZsm1+osNbG8sB13v29782IODmiLvTaHhxkJR5T2+LahsW1a6/
        vIO5rpTYPjd5ROTDdjbeDOx//hIcF5q8nlq93cDGjdkjgIekHcuIK17MbXjVydSLYMtNTk
        vxHhjuwVME+5Wu2p6aUiY9LWUtHUKfY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-J00p_R2NP6CrzUdOxsTrXw-1; Wed, 28 Jun 2023 03:44:50 -0400
X-MC-Unique: J00p_R2NP6CrzUdOxsTrXw-1
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-3ff29a61c36so66860901cf.0
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687938289; x=1690530289;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gEFCO6LP8mfvqL0i/v3L1hgRp+ixmHtRy0L/FBujzDA=;
        b=G50o2172xXkS3LQYIzxyLyV8dhKupKD2hzePboWr/dh1R0AA9xqpjdHUmPssLZYonf
         9rTAR8FOpCJndoEAx1b1yIDedA1UmOqp0fUwTpU+YbGMXDYOQzqWxOeQzqbNYFTo/aIl
         uCZLv0OozOPpLAm8DNuxO1Eoyw3NLqoyFEhBAkC71uW9jcrCU/o7iJuamTPYqnSDbjLK
         hNb+J2j8f6pHZB3sx0hlcPu3WHPhGYoCPfPltJPHX6VgUnrhjXmjIdF2m6/uUxxeu55Y
         xFgR1LUOL2d8jVGSsOYl0L9VAA5pZOXiu7WevlvculprQznesHC0ZZlFgqlMNfY2EU7S
         IjDw==
X-Gm-Message-State: AC+VfDzMxImopYzgEcBWpYNfFCPsVDZ+o3+vPbSKcByu8vcRvntXM00w
        vt2Jw+oZaGIBigEDx7DweJH44baIA+F/odys0F29GOZF/lpqA4y9luwZUtMAXU8YrMpCPZb79cd
        4ZXgySobTYITT
X-Received: by 2002:ac8:5a11:0:b0:3fd:eaa8:ec5e with SMTP id n17-20020ac85a11000000b003fdeaa8ec5emr35303829qta.20.1687938289508;
        Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7tZCFozSAn4f8mm7MZh1tWv2n+U+GKLaivskq116PeuxTrtCfVJ34biBb/+bMKM6LiqyNV+A==
X-Received: by 2002:ac8:5a11:0:b0:3fd:eaa8:ec5e with SMTP id n17-20020ac85a11000000b003fdeaa8ec5emr35303818qta.20.1687938289224;
        Wed, 28 Jun 2023 00:44:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id bn4-20020a05622a1dc400b004009f034a6csm4169643qtb.91.2023.06.28.00.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 00:44:48 -0700 (PDT)
Message-ID: <0aa48994-96b3-b5a1-e72b-961e6e892142@redhat.com>
Date:   Wed, 28 Jun 2023 09:44:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 0/6] arm: pmu: Fix random failures of
 pmu-chain-promotion
Content-Language: en-US
To:     eric.auger.pro@gmail.com, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, ricarkol@google.com,
        reijiw@google.com, alexandru.elisei@arm.com
Cc:     mark.rutland@arm.com
References: <20230619200401.1963751-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230619200401.1963751-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru, Drew,

On 6/19/23 22:03, Eric Auger wrote:
> On some HW (ThunderXv2), some random failures of
> pmu-chain-promotion test can be observed.
>
> pmu-chain-promotion is composed of several subtests
> which run 2 mem_access loops. The initial value of
> the counter is set so that no overflow is expected on
> the first loop run and overflow is expected on the second.
> However it is observed that sometimes we get an overflow
> on the first run. It looks related to some variability of
> the mem_acess count. This variability is observed on all
> HW I have access to, with different span though. On
> ThunderX2 HW it looks the margin that is currently taken
> is too small and we regularly hit failure.
>
> although the first goal of this series is to increase
> the count/margin used in those tests, it also attempts
> to improve the pmu-chain-promotion logs, add some barriers
> in the mem-access loop, clarify the chain counter
> enable/disable sequence.
>
> A new 'pmu-mem-access-reliability' is also introduced to
> detect issues with MEM_ACCESS event variability and make
> the debug easier.
>
> Obviously one can wonder if this variability is something normal
> and does not hide any other bug. I hope this series will raise
> additional discussions about this.
>
> https://github.com/eauger/kut/tree/pmu-chain-promotion-fixes-v3
>
> History:
>
> v2 -> v3:
> - took into account Alexandru's comments. See individual log
>   files
Gentle ping. Does this version match all your expectations?

Thanks

Eric
>
> v1 -> v2:
> - Take into account Alexandru's & Mark's comments. Added some
>   R-b's and T-b's.
>
>
> Eric Auger (6):
>   arm: pmu: pmu-chain-promotion: Improve debug messages
>   arm: pmu: pmu-chain-promotion: Introduce defines for count and margin
>     values
>   arm: pmu: Add extra DSB barriers in the mem_access loop
>   arm: pmu: Fix chain counter enable/disable sequences
>   arm: pmu: Add pmu-mem-access-reliability test
>   arm: pmu-chain-promotion: Increase the count and margin values
>
>  arm/pmu.c         | 208 ++++++++++++++++++++++++++++++++--------------
>  arm/unittests.cfg |   6 ++
>  2 files changed, 153 insertions(+), 61 deletions(-)
>

