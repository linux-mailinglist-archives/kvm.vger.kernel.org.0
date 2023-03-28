Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554286CB567
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 06:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjC1EZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 00:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC1EZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 00:25:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024E21BF6
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:25:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3-20020a250b03000000b00b5f1fab9897so10873549ybl.19
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 21:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679977548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/g2oOBt3fnHvhuZ+/OpXz3oK1hh+HMHZTM0flSISmM=;
        b=rPKNqVZNoZ3RoZNn3SiCGIolef2h8XiptmsZ85NY3F0BsyVHLNDKu1ySx+fezUG7h4
         EMzyrUm+tE6+sCV595iiV8RkuJbjleRaAmMSCLV/O0rlpPCyIakmMemXtVzx08FZyYEt
         Ox2NIc3NKvQPUzxSXcEJHJOFlmcJiIRlFM5zGwc8o9CFu7VA7/xWfffok+/3U27UKRVY
         Pu9+kMtt4QMs5bHA4jzpvmczu1DVdsPgKWXQ8vG3iL58BXpbS0x48u2jqfSa93zJfkJB
         kP1ZxOgvdPWw8UiG8JfjkPUt0D7CJHbM9UqyJ1r8Cpm05FEvPIHqLYL/k4KflA5QC1xC
         qFuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679977548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/g2oOBt3fnHvhuZ+/OpXz3oK1hh+HMHZTM0flSISmM=;
        b=dYIYN9wQPO/zu+AFvB6MUX7JdHFeiAogIbfxmzPAHTyV2majb2KO4vILRehg0gcYBl
         T+YFScNZkAnxnyvrOD6JLlrWZip6II+RKhsqPej9QqK6BMCSX+Nb9us6gc191CctPFCc
         Y1T/7lHM945w9B8+Dl9gaExshm3pANSQVTT6CdLTu0bWTwfA/b4uCr8FMlG0mL8CJUjF
         r+XrJVetMS5RCReNFOUmuHyOdbdXN1MqP2yNXc9j1w1TuPQsz0a8sutZ+eM9Iz+WkIOe
         W2A9vBIBaDXins9h29DSnuXJidCWygWwBhsVtjymEa02VJTuMZ3+551D/YvLPgNJ8QPt
         D/sQ==
X-Gm-Message-State: AAQBX9fLMZslzC1o9goaXKlheCSwG3d4wNlNFfVCSYrC9hLIyyf4K8dK
        9jvjrkgCimTIbgyK18aTw+3c9Pn5r6M=
X-Google-Smtp-Source: AKy350ZF+TYemosLPRlWdIU4J0E3li9oyPmyuXj39I9OOZQ7e1RwJVK6pL9zmErTbdE50f0rRCbkIpgcHi0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac08:0:b0:544:8ac7:2608 with SMTP id
 k8-20020a81ac08000000b005448ac72608mr6304495ywh.6.1679977548296; Mon, 27 Mar
 2023 21:25:48 -0700 (PDT)
Date:   Mon, 27 Mar 2023 21:25:47 -0700
In-Reply-To: <20230327175457.735903-1-mhal@rbox.co>
Mime-Version: 1.0
References: <20230327175457.735903-1-mhal@rbox.co>
Message-ID: <ZCJsSySJDsMtKdEa@google.com>
Subject: Re: [PATCH] KVM: Don't kfree(NULL) on kzalloc() failure in kvm_assign_ioeventfd_idx()
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023, Michal Luczaj wrote:
> On kzalloc() failure, taking the `goto fail` path leads to kfree(NULL).
> Such no-op has no use. Move it out.

Huh, the original commit had the funky code, e.g. it wasn't a case of avoiding
labels or anything.

> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
