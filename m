Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3456E747F
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 09:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjDSH4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 03:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjDSH4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 03:56:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3ADC2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681890958;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=SrDd8kW+w0DCaJKCEOAWSxq/P7lG0SjBmMooUk9r3Dc=;
        b=ORXRdGX/aouuTXF4QepFMoNTYkRQTDsJ9yGVHFwL5iE7Tus/NkKPh0aGwiVskB6t86XKwC
        Tb5OC6FrExU8LF6HJGR/bOXpruTosi/bDh9GG/ySicZsRgeyCpU900mJRXQi0tngIKlQcv
        +WkHMNyjEXX6fmnmAbI6hj36qZ+tUo8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-MKPPhV_bM8-uKTQAhDhRHw-1; Wed, 19 Apr 2023 03:55:57 -0400
X-MC-Unique: MKPPhV_bM8-uKTQAhDhRHw-1
Received: by mail-wr1-f70.google.com with SMTP id l4-20020adfa384000000b002f4585d0ec9so3345615wrb.15
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681890955; x=1684482955;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SrDd8kW+w0DCaJKCEOAWSxq/P7lG0SjBmMooUk9r3Dc=;
        b=C4rBI+AVSNskK3Rh8KAXKCyeOUoYmRsbHP5w2v2OxckT/JBe93Xyxl3a7wNyh+nfZb
         SNUNOOpUkfSrLpFwJ4OvQkVREfUfHWlvuXuMSQLUjjG01t3+zVqtb8SCmOd6hssG3K6Q
         72bgSIePah/fDFTrpgsuidj/c8bRGmQ2DeXK7cI2vIEJFF0Avd/8R+rg7uJ4ajrVtRLg
         LhBLOlkAaP0EmUBUEyO7KCqEwGHKFEaKAC6g4nV5Wfm/KzCH3mw3AxtXycEC4rSkNLW6
         9xi1/win6915UHmLbWAeSIYlOAPAbN3zTiGlw+P4B4SUqOpFwzGNXTxjvLinOcm3Xj2D
         wNWw==
X-Gm-Message-State: AAQBX9f5+kotVgT4aXVSZNIOu4VitsWvZOYavgDOxp1Y5bnrLvaPSYeC
        GVnXE/PBQbfY91alxqnLMGfdHirHWhtxRo7oImvcw538HCbtBkJ/vRZgmoR1j11fN1RK+DbXFOT
        Av87LeoPGQq3Do9oEMrkDPJpjtMLDviClJmAf64LOojR1oLjxBpJGxROzg7QvAVPrqbd9T4TvyN
        Ccfg==
X-Received: by 2002:a7b:c7c9:0:b0:3f1:6ecf:537 with SMTP id z9-20020a7bc7c9000000b003f16ecf0537mr9924959wmk.33.1681890955094;
        Wed, 19 Apr 2023 00:55:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYaRM8bZF69Wg31uI9cc56cZlQSgc5rNzXbZToFP+FrglvkH5WSr9/erQTEd2v9V0PZCD/aQ==
X-Received: by 2002:a7b:c7c9:0:b0:3f1:6ecf:537 with SMTP id z9-20020a7bc7c9000000b003f16ecf0537mr9924940wmk.33.1681890954760;
        Wed, 19 Apr 2023 00:55:54 -0700 (PDT)
Received: from redhat.com (static-214-39-62-95.ipcom.comunitel.net. [95.62.39.214])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c000900b003f0aa490336sm1309023wmc.26.2023.04.19.00.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 00:55:54 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call minutes for 2023-04-18
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 19 Apr 2023 09:55:53 +0200
Message-ID: <87mt341f1y.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

We started testing with recording the call, will 


Update on icount

Enable icount to be "enabled" independently of tcg.

icount + ttcg breaks, so there needs to be done some changes here.

The plugin allows to plug into the timer subsystem, so all the times are available.

Having multithread ttcg makes things complicated.

We don't want three versions of icount:
- deterministic
- multithread
- ....

The plugin only allows some primitives to handle the times, not the
full power of TCG.

We will try to break out the icount generation without disturbing
determinism.

The plugin will be able to calculate the time, and everything else
will read it from there.

The current code will continue to be as it is, and will not work with
multithread ttcg.


We got a recording of the call here:

https://fileserver.linaro.org/s/nJTSCLyQBfo6GLJ

Thanks to Alex for storing it.

Later, Juan.

