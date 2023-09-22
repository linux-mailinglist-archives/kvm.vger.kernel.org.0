Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96F07AB4EB
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbjIVPk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjIVPk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:40:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EBF102
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:40:22 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE9AC433C8;
        Fri, 22 Sep 2023 15:40:19 +0000 (UTC)
Date:   Fri, 22 Sep 2023 16:40:17 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, maz@kernel.org,
        will@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        zhukeqian1@huawei.com, jonathan.cameron@huawei.com,
        linuxarm@huawei.com
Subject: Re: [RFC PATCH v2 4/8] KVM: arm64: Set DBM for previously writeable
 pages
Message-ID: <ZQ21YYGqcAhOq/UO@arm.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
 <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230825093528.1637-5-shameerali.kolothum.thodi@huawei.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 25, 2023 at 10:35:24AM +0100, Shameer Kolothum wrote:
> We only set DBM if the page is writeable (S2AP[1] == 1). But once migration
> starts, CLEAR_LOG path will write protect the pages (S2AP[1] = 0) and there
> isn't an easy way to differentiate the writeable pages that gets write
> protected from read-only pages as we only have S2AP[1] bit to check.

Don't we have enough bits without an additional one?

writeable: DBM == 1 || S2AP[1] == 1
  clean: S2AP[1] == 0
  dirty: S2AP[1] == 1 (irrespective of DBM)

read-only: DBM == 0 && S2AP[1] == 0

For S1 we use a software dirty bit as well to track read-only dirty
mappings but I don't think it is necessary for S2 since KVM unmaps the
PTE when changing the VMM permission.

-- 
Catalin
