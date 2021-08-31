Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCCF3FCA66
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhHaOzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:55:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237512AbhHaOzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Aug 2021 10:55:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E2E1604D7;
        Tue, 31 Aug 2021 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630421669;
        bh=6DEaxovf9hyUKjkGX9gnE91O7ca9cHejc9mA4k4jsag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tKZHEWwLIUc7FzcrwxSjjoi/L+kaY3KVSMlzV30OQKJPdzO88w+Tmd8vcQDhdsRJk
         RpdQt0wu2tFoVr8yRD7X6N3VJ7dBAX8SZEEE2g0wRP/xPTu01weXwA7VO/MGHJuwpW
         pKCoiaDaYJPLMi3prc1RlIiVPMOwqkupGsbx5dGjN278ZZZP5Ib//ziNmsregj3iFs
         bOujOh37I2zW1fR3vMpA1/6VahNmLl5U68EuBwcCJfC3m5mKhtZC3sYVEnOd7hkmmz
         PzD8ZF30VjjNHnRvv0vwLefRdSqYJyFYJOs28XcvqDuybKRN13RmdBVtZ5ZbBz7/fM
         61qRwFW+muZDQ==
Date:   Tue, 31 Aug 2021 15:54:24 +0100
From:   Will Deacon <will@kernel.org>
To:     Vivek Gautam <vivek.gautam@arm.com>
Cc:     julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
        andre.przywara@arm.com, alexandru.elisei@arm.com,
        lorenzo.pieralisi@arm.com, jean-philippe@linaro.org,
        eric.auger@redhat.com
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
Message-ID: <20210831145424.GA32001@willie-the-truck>
References: <20210810062514.18980-1-vivek.gautam@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810062514.18980-1-vivek.gautam@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 11:55:14AM +0530, Vivek Gautam wrote:
> Add support to parse extended configuration space for vfio based
> assigned PCIe devices and add extended capabilities for the device
> in the guest. This allows the guest to see and work on extended
> capabilities, for example to toggle PRI extended cap to enable and
> disable Shared virtual addressing (SVA) support.
> PCIe extended capability header that is the first DWORD of all
> extended caps is shown below -
> 
>    31               20  19   16  15                 0
>    ____________________|_______|_____________________
>   |    Next cap off    |  1h   |     Cap ID          |
>   |____________________|_______|_____________________|
> 
> Out of the two upper bytes of extended cap header, the
> lower nibble is actually cap version - 0x1.
> 'next cap offset' if present at bits [31:20], should be
> right shifted by 4 bits to calculate the position of next
> capability.
> This change supports parsing and adding ATS, PRI and PASID caps.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
> ---
>  include/kvm/pci.h |   6 +++
>  vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 103 insertions(+), 7 deletions(-)

Does this work correctly for architectures which don't define ARCH_HAS_PCI_EXP?

Will
