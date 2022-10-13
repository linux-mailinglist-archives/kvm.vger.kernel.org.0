Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0715FD0C8
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 02:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiJMAaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 20:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiJMA2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 20:28:37 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC330171CE4
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 17:25:30 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d10so498566pfh.6
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 17:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7whd1nR2fxk/R3cx2zyxmptqUHfIbD5kvw3pDYFzeY=;
        b=e566s0v9gEdcj855wSrlCgX4YHujADy4NcAJWC9Hw8Xqj3kQVu0jVG6JAlWRUPnA2d
         yMUNl1hul0C3uJu8TMi93rbQDQjmNNir0NL2bFhBAaqpzPr8L93y3rS6uhzXM/dOf/0l
         h30s45JEPeLSOFq5sKQjtBbuLeDyndNpZg8V1UCuKHzS/X5UB3t0eg5Z83V51RUKAa3v
         XKRLj6hUCg0gBjVVI39A8o4HbwkzVDGGQz14VUh0SCtFjmzz/Cf4rpjLngnD8rPNRa8T
         CVL68UmBzXVxXanfxMyH/rWWwwNsrZezOUnw8ffeK/8e9pekpJ4uUj/iGD/FbXUH7qb3
         ywEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K7whd1nR2fxk/R3cx2zyxmptqUHfIbD5kvw3pDYFzeY=;
        b=yh35VPDP4i7fRU7KurQhcamU2ai/vQm7Tdji0YTAZiXiejwfa4KCNkbGku8EV8caXH
         NmFKVbFxvv/MbS4oLY6HCcT1YYQlXoMSr+7y2rVkbnGw+6HNLfA+YfxxuEjcJqZn+0MU
         8i01qk2vUUKbTrzP65fHJQQq64uR0Rg+0YEtiIWA1qpWiTeQ+1u/SQKHqNkz1FCPrmYy
         Z8H1ildnvu567UinW3cwPlliYjqoGGr56w1DznLbbL6gFEsKcU7Uj+Vck/xX9va32reM
         EbgmKoJKdFVaOpYlx0q0DeqM1mvJFWi+KvM4+2U3PPA1M94RJ/ur2ppWRGtkGb6t6bGB
         z1Sg==
X-Gm-Message-State: ACrzQf0YfeypRtRHnu4H2TJhf+WZEFEif4JpBxZiMRmV9+Z9DoMkhQKB
        GY2M0eE2MDePUDr/v57+dKFTtA==
X-Google-Smtp-Source: AMsMyM7U3ZOfPGst/WeZswFT/39Idt5/dCb2XWX4uzAW6+oLRyDTmnV8VxXSnqpodQSFBE/Vjs0J5g==
X-Received: by 2002:aa7:93a8:0:b0:563:4dc2:9e5f with SMTP id x8-20020aa793a8000000b005634dc29e5fmr20061854pff.68.1665620543941;
        Wed, 12 Oct 2022 17:22:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w187-20020a6262c4000000b00562f431f3d2sm460119pfb.83.2022.10.12.17.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 17:22:23 -0700 (PDT)
Date:   Thu, 13 Oct 2022 00:22:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 8/8] KVM: x86: Fix NULL pointer dereference in
 kvm_xen_set_evtchn_fast()
Message-ID: <Y0daPIFwmosxV/NO@google.com>
References: <YySujDJN2Wm3ivi/@google.com>
 <20220921020140.3240092-1-mhal@rbox.co>
 <20220921020140.3240092-9-mhal@rbox.co>
 <Y0SquPNxS5AOGcDP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0SquPNxS5AOGcDP@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 10, 2022, Sean Christopherson wrote:
> On Wed, Sep 21, 2022, Michal Luczaj wrote:
> If this fixes things on your end (I'll properly test tomorrow too), I'll post a
> v2 of the entire series.  There are some cleanups that can be done on top, e.g.
> I think we should drop kvm_gpc_unmap() entirely until there's actually a user,
> because it's not at all obvious that it's (a) necessary and (b) has desirable
> behavior.

Sorry for the delay, I initially missed that you included a selftest for the race
in the original RFC.  The kernel is no longer exploding, but the test is intermittently
soft hanging waiting for the "IRQ".  I'll debug and hopefully post tomorrow.
