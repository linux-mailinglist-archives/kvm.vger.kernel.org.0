Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E4C1BD7B1
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 10:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgD2Iz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 04:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726526AbgD2Iz0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 04:55:26 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15241C03C1AD;
        Wed, 29 Apr 2020 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Zg05Vm1A2lWxdDTSbC31qKzMIS0QAm8Czd7xgSjK0I8=; b=uNlGpVWiBRXOs6DApIQWTZuVZE
        RhDFDS5L7eAJF5AffAu8Ac1KH7ikAh+hPua1pwtAVz9SZmPbhpeuNlTpOM1QCA+XBvoOIWy6A/0wM
        M1gYnQ/ynZM+4uu1DQqkSGdwHVJPnsLJg2lcPkf57CEh2OYR/Bi7q4EDUSSxCVQlAkNNY/EIDVj4Q
        Cpp2c6FX/zdzWHv4oFae2qV7DR8LwpIoTPonZqhkbg2FN/Ekyhexby+tBunhx87heZA5ZjmvlBdf2
        4l2v5txxq4K8w3+eKsYobX7kylAqsLi12gXGUVAiFuyrgS9RIVTjKYGWPcYOI2Vy1BOg6Fk7sjydK
        jptRlmkQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jTiUN-0007Ty-6x; Wed, 29 Apr 2020 08:54:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 0766F300130;
        Wed, 29 Apr 2020 10:54:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E71C520BD8FF6; Wed, 29 Apr 2020 10:54:40 +0200 (CEST)
Date:   Wed, 29 Apr 2020 10:54:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        hpa@zytor.com, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
        joro@8bytes.org, jmattson@google.com, wanpengli@tencent.com,
        vkuznets@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: Re: [PATCH][v2] kvm: x86: emulate APERF/MPERF registers
Message-ID: <20200429085440.GG13592@hirez.programming.kicks-ass.net>
References: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1588139196-23802-1-git-send-email-lirongqing@baidu.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 29, 2020 at 01:46:36PM +0800, Li RongQing wrote:
> Guest kernel reports a fixed cpu frequency in /proc/cpuinfo,
> this is confused to user when turbo is enable, and aperf/mperf
> can be used to show current cpu frequency after 7d5905dc14a
> "(x86 / CPU: Always show current CPU frequency in /proc/cpuinfo)"
> so we should emulate aperf mperf to achieve it
> 
> the period of aperf/mperf in guest mode are accumulated as
> emulated value, and add per-VM knod to enable emulate mperfaperf
> 
> diff v1:
> 1. support AMD
> 2. support per-vm capability to enable

Would it make sense to provide a pass-through APERF/MPERF for
KVM_HINTS_REALTIME ? Because that hint guarantees we have a 1:1 vCPU:CPU
binding and guaranteed no over-commit.
