Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E573001F8
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 12:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbhAVLue (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 06:50:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbhAVLsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 06:48:35 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321AE22CA1;
        Fri, 22 Jan 2021 11:47:54 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1l2uuu-009P1V-1R; Fri, 22 Jan 2021 11:47:52 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 22 Jan 2021 11:47:51 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Yanan Wang <wangyanan55@huawei.com>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>,
        Quentin Perret <qperret@google.com>,
        wanghaibin.wang@huawei.com, yezengruan@huawei.com,
        yuzenghui@huawei.com
Subject: Re: [RFC PATCH v4 0/2] Some optimization for stage-2 translation
In-Reply-To: <20210122101358.379956-1-wangyanan55@huawei.com>
References: <20210122101358.379956-1-wangyanan55@huawei.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <a6d4d16574fa76c4e519cdbff70cf950@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangyanan55@huawei.com, will@kernel.org, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, gshan@redhat.com, qperret@google.com, wanghaibin.wang@huawei.com, yezengruan@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yanan,

On 2021-01-22 10:13, Yanan Wang wrote:
> Hi, Will, Marc,
> Is there any further comment on the v3 series I post previously?

None, I was planning to queue them for 5.12 over the weekend.

> If they are not fine to you, then I think maybe we should just turn
> back to the original solution in v1, where I suggestted to filter out
> the case of only updating access permissions in the map handler and
> handle it right there.
> 
> Here are the reasons for my current opinion:
> With an errno returned from the map handler for this single case, there
> will be one more vcpu exit from guest and we also have to consider the
> spurious dirty pages. Besides, it seems that the EAGAIN errno has been
> chosen specially for this case and can not be used elsewhere for other
> reasons, as we will change this errno to zero at the end of the 
> function.
> 
> The v1 solution looks like more concise at last, so I refine the diff
> and post the v4 with two patches here, just for a contrast.
> 
> Which solution will you prefer now? Could you please let me know.

I'm still very much opposed to mixing mapping and permission changes.
How bad is the spurious return to a vcpu?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
