Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D22767E969
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 16:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbjA0P0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 10:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbjA0P0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 10:26:36 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B9C7B43B
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:26:34 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so5270029wrb.11
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 07:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1tjEUzLFjJmxfniuCdsNKzTQp/eXm9sRTYtnzkPTRGE=;
        b=KUexmgRu5iOOfgI9R349Jd8L2TyoFbY1EsZAokQ3a/7AM3waZn4yATTO1YrXdP8Kkx
         z/0f4L+QJcoDx5Jc2YiSJDMPuTJ8B0SXLJYGhAos7+7yimV3ZtsDMFRmIYhi7FSEGK0Y
         0B+2LfXh35sh1pdV9VUXz7s1hPuuZWjSLwlxaL61ndTEOwewE8naS+Pd3OlyBQ1zracL
         G67VJ+/oXtHG3eqDbpQiGSLl0vkaz+vnpH11xG7Wniomm6Pe5ayefFZsoihv6HZzdawf
         LIxM+KFl8helJIKHG11992tvJf6aFjAuN8VirRkVvAePOWtSP4Qj3mwuE446HVJWsbHR
         GCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tjEUzLFjJmxfniuCdsNKzTQp/eXm9sRTYtnzkPTRGE=;
        b=mAgzd/AlFzOfLVIsbmj6FYtYforiPRyzqqyB0zYXMANgKgAxZ0niTvI5BgBFxyBXiD
         6/k5rlKxynOmAcS1AgJzayMLLanklekBry7RYW/J/f7SZc1YC2eiKo5T+AKktWFAGqBC
         fZMLcsUhwcHl9LCFr/m2Wx9Vt6HF091v+mrIAh0Xz9PJtCuHMR0M+0sICb/0pl/gkoUP
         nzqYl5BBvXQghs4b+ab8uB2JhtpugT9ksCywURyAvPoOTdakDaguvR4y9AXfQ6sSDbZ7
         JSieNshWrYn/x3BAHa46TaP8ydmWswPi/0VNLNIXxhNJhRQ9OLCPwZsX92ScgxugAqqQ
         JqZQ==
X-Gm-Message-State: AFqh2krseQy47sdSmwl4IyGyNytQBx7qK1ci6oyw/JodvnNMIKnZo6f1
        lAxZ9GNUQ+2T0JCKY2X79rjirg==
X-Google-Smtp-Source: AMrXdXva7H5XWHDFiLRxpONdNSBqnohgqBGHD8HwUdzNKwIZrLMJ1OzcPdG5hlDJpM6rYIT+Ntu+kQ==
X-Received: by 2002:a5d:5083:0:b0:2be:546c:4663 with SMTP id a3-20020a5d5083000000b002be546c4663mr23900328wrt.45.1674833192983;
        Fri, 27 Jan 2023 07:26:32 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id e7-20020adfe387000000b002be15ee1377sm4265350wrm.22.2023.01.27.07.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:26:32 -0800 (PST)
Date:   Fri, 27 Jan 2023 15:26:32 +0000
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <Y9PtKJ3Wicc19JF1@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127112248.136810-1-suzuki.poulose@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 27, 2023 at 11:22:48AM +0000, Suzuki K Poulose wrote:
> We are happy to announce the early RFC version of the Arm
> Confidential Compute Architecture (CCA) support for the Linux
> stack. The intention is to seek early feedback in the following areas:
>  * KVM integration of the Arm CCA
>  * KVM UABI for managing the Realms, seeking to generalise the operations
>    wherever possible with other Confidential Compute solutions.

A prototype for launching Realm VMs with QEMU is available at:
https://lore.kernel.org/qemu-devel/20230127150727.612594-1-jean-philippe@linaro.org/

Thanks,
Jean

