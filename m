Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A356859E748
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 18:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244695AbiHWQaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 12:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242703AbiHWQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 12:29:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0171F2FF
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 05:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661259431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Y9LKZY2kmFCyQs+oe+1C/W64milf2e76Lj/8BkwVowc=;
        b=OoXFronLAd10Lti+nAB6Co2Ik7NajBLpua+iCDSBrajmceLBkLiTnI2TJ7U53yi4l96KoI
        7crkX9ApvjphK8a4d/oxHoT0FfehwkIzq5EogKhe1+yLL+WgcSUilAp2lU88ZpHw3h8FHn
        hB6LenWuyujgeCWE+/rLv406tmc8DOs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-638-hD-5Wq9_Pq6BzzMpAbzPng-1; Tue, 23 Aug 2022 08:57:07 -0400
X-MC-Unique: hD-5Wq9_Pq6BzzMpAbzPng-1
Received: by mail-qv1-f70.google.com with SMTP id n9-20020a0cfbc9000000b00496bb293f1fso7001940qvp.1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 05:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc;
        bh=Y9LKZY2kmFCyQs+oe+1C/W64milf2e76Lj/8BkwVowc=;
        b=yqI/5tU/GsJk8EU6iyuD4MwbSZCLgrxQ5uGAbM78YJhxBi08i9mrSRf5xkeMDlBTnp
         zFDx0pPMhTxs9cYau5B8COO8kCeJkaWb7I3EJQNjm895eWpRN90S7wEswVmY5ackDng0
         yL8TbihApMxbTMU5i8drq8BQij7Ls/sTbqbpVJ9qHO38nqDdcz/VSc3TqKFuu8scCvHK
         2YBVEwdNvcMV8A7/0zXloU9nMTBLsCB4OPRgsk3EkYvzrFSRPciB3nk8C1NiLHtbzHAt
         nKzrbh+IZeRXLS6Ly0op+163EIYkGYEBKWQS1Fuk0TnroxeCx5GPwray4aO40omebntG
         SJog==
X-Gm-Message-State: ACgBeo3yIHkrRrf2p8wYttTFkeEOW6YhTiXrsRyzk2QLpBTERG6MAOb2
        6gzqEBNJW/SgyUDobzpOqbz42Ek9ptHh7dEVegrJGiPYVOZVj5gioye8+fiGoRCVoVW2db/kwNk
        Oo403oXYdAfyN
X-Received: by 2002:ac8:5889:0:b0:344:57e5:dc54 with SMTP id t9-20020ac85889000000b0034457e5dc54mr19480634qta.465.1661259426808;
        Tue, 23 Aug 2022 05:57:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7B7cu076JtEOfRpGLIW8wss7Qd+yeJoVC+QUZHOm2ldYv0lpde6xlWoWAqGD+Hv2kV2iJ2kQ==
X-Received: by 2002:ac8:5889:0:b0:344:57e5:dc54 with SMTP id t9-20020ac85889000000b0034457e5dc54mr19480618qta.465.1661259426610;
        Tue, 23 Aug 2022 05:57:06 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id q15-20020ac8450f000000b003447ee0a6bfsm10709695qtn.17.2022.08.23.05.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 05:57:06 -0700 (PDT)
Message-ID: <cdbe3d8d07557d73d7a96cd4a69e717574494e34.camel@redhat.com>
Subject: FYI:  xapic_state_test selftest fails with avic enabled
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Date:   Tue, 23 Aug 2022 15:57:03 +0300
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

I just noticed that this test fails when the AVIC is enabled.

It seems that it exposes actual shortcomings in the AVIC hardware implementation,
although these should not matter in real life usage of it.


First of all it seems that AVIC just allows to set the APIC_ICR_BUSY bit (it should be read-only)
and it never clears it if set.

Second AVIC seems to drop writes to low 24 bits of to ICR2, because these are not really used,
although technically not marked as reserved in the spec (though APIC_ID register in AMD spec,
states explicity that only bits 24-31 can be set, and the rest are reserved).

And finally AVIC inhibit when x2apic is exposed to the guest was recently removed,
because in this case AVIC also works just fine (but with msr emulation) and that
means that we don't need anymore to hide x2apic from the guest to avoid AVIC inhibit.

Best regards,
	Maxim Levitsky

