Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC127D1BFF
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 11:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjJUJLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Oct 2023 05:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjJUJK7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Oct 2023 05:10:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5EE10CA;
        Sat, 21 Oct 2023 02:10:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D006C433C8;
        Sat, 21 Oct 2023 09:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697879454;
        bh=nooTBPOV1b+3XpXMfXZty/WQcMVOJOlAfpiWnEipiEc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kKTI2ON2rmB5eb4ObvDDX1t0PcfbaSEMyu/9J0GRvxDyH8xScoKFABoQbpBG5rSG3
         vqZ/5EaVpSc+tHKUXsayXQOB0DiP+315ltStRGGovA3VodQwXq8BhvZ5aQ9ISuxijO
         vwgpObedYh3EOCVIwVdD0QRpjgza1lnMtf6aYbQA=
Date:   Sat, 21 Oct 2023 11:10:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Matlack <dmatlack@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, stable@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pattara Teerapong <pteerapong@google.com>,
        David Stevens <stevensd@google.com>,
        Yiwei Zhang <zzyiwei@google.com>,
        Paul Hsia <paulhsia@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Stop zapping invalidated TDP MMU roots
 asynchronously
Message-ID: <2023102145-unstylish-vertigo-ab7c@gregkh>
References: <20231019201138.2076865-1-seanjc@google.com>
 <ZTLMcmj-ycWhZuTX@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTLMcmj-ycWhZuTX@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 11:52:34AM -0700, David Matlack wrote:
> On 2023-10-19 01:11 PM, Sean Christopherson wrote:
> > [ Upstream commit 0df9dab891ff0d9b646d82e4fe038229e4c02451 ]
> > 
> > Stop zapping invalidate TDP MMU roots via work queue now that KVM
> > preserves TDP MMU roots until they are explicitly invalidated.  Zapping
> > roots asynchronously was effectively a workaround to avoid stalling a vCPU
> > for an extended during if a vCPU unloaded a root, which at the time
> > happened whenever the guest toggled CR0.WP (a frequent operation for some
> > guest kernels).
> > 
> [...]
> > 
> > Reported-by: Pattara Teerapong <pteerapong@google.com>
> > Cc: David Stevens <stevensd@google.com>
> > Cc: Yiwei Zhang<zzyiwei@google.com>
> > Cc: Paul Hsia <paulhsia@google.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > Message-Id: <20230916003916.2545000-4-seanjc@google.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: David Matlack <dmatlack@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Tested-by: David Matlack <dmatlack@google.com>
> 
> (Ran all KVM selftests and kvm-unit-tests with lockdep enabled.)

Thanks, now queued up.

greg k-h
