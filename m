Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F136543594
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbiFHOwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243283AbiFHOsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A4C27B997;
        Wed,  8 Jun 2022 07:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2954C61BD5;
        Wed,  8 Jun 2022 14:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C1BC36B09;
        Wed,  8 Jun 2022 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654699678;
        bh=HljlLAHDqRd1MfI/qsaUULNG20X+Hd75Y5ZizDpKfOI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=paIcKmkyKe60i3YfyYi4oMwSTAEJ9cclIU5sev9RcJHT8h9NAnMf+9sHY2UNkFyvD
         CCes3zrsosjyTPurCGh1E1Zkq8WBQfKyRBkkvvuPNXHym3AjLVeXSh9zACVMy/4HWu
         wEmM5pL+yvhdVl8b2XVKFqbwLWjNzVXFnIrIWc5Jvj1ExaPZUV0/q+Zn+X4/FScLcf
         6gRYT+MhP/twGBkE/jr8Yt4eQht+yyK71cEpWvqBGGUtEtfqh4TYwJpMt+/Tz5sd4p
         5aIK+Y/+QVK9Jn8o2p3WobubbCdMC8xPbRihE3QUBCJkdXBFVWL218zVNUalmxpO8p
         qTlZL/YX+uNsw==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nywyS-00GdIy-65; Wed, 08 Jun 2022 15:47:56 +0100
MIME-Version: 1.0
Date:   Wed, 08 Jun 2022 15:47:55 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        anup@brainfault.org
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
In-Reply-To: <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <93b87b7b5a599c1dfa47ee025f0ae9c4@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org, vkuznets@redhat.com, drjones@redhat.com, dmatlack@google.com, bgardon@google.com, oupton@google.com, linux-kernel@vger.kernel.org, sean.j.christopherson@intel.com, anup@brainfault.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-06-07 16:27, Paolo Bonzini wrote:
> Marc, Christian, Anup, can you please give this a go?

Can you please, pretty please, once and for all, kill that alias you
seem to have for me and  email me on an address I actually can read?

I can't remember how many times you emailed me on my ex @arm.com address
over the past 2+years...

The same thing probably applies to Sean, btw.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
