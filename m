Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C3F6AA110
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjCCVYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjCCVYP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:24:15 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D49D16302
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:24:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id i5so4150542pla.2
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677878654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5BKYy3m+qxvOSaSlV2CaAxy3p3ZlB+LsjzpmDKHhpSw=;
        b=CHwpP/DQZdWAgnFKSEQ8ZtRT/6f4MEuLEcYWTKlUEaovGu73s4LDQ+IBIUsr2PLgmj
         BIPGLnyC9XBE3IUva2hQeAlcqk5U3wM2ZHHu8fOTOeeO2nWb72mlRVFV4P7q47ap9K0H
         gwAUZp3WzTqquVSHmpdvidHbWhVFlMrqCi3GBzmkPBj8ZCuLkuBgT3S6iFde5FdOF/0X
         W++5gObuAdq53ReABb2IgRt//EACkptw0RD9P5LwhtoJbzRhJet1Qe1PbEqlq7S+Hm5u
         zPLLQr6FivM7UgpGx4ws2M07ds+G2oAmLBDqUb2PNZPL+89WdNS8RPTn9ZJoUp/GEmD4
         OiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677878654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5BKYy3m+qxvOSaSlV2CaAxy3p3ZlB+LsjzpmDKHhpSw=;
        b=Jc9ZgWmzEDUYoFOTJCnNZLYLtBzQllA6xFM7s/Zc0IkMIzcVFbXTVcQTgLY9l/GW4h
         84pk+hJ+bNjWKgpNyWPxYUxHBTMmcHdwUSIYRycJUNTLkeZ+jTCdrO9mNLuK6guPcw/g
         VoiGPTjnmduBXmaMoD1ScGa8f25OOeWNlS+qw1B5xlfSLuPzsFZl5XELoaJPPhrBLTV6
         uvUppNHcXnLcOlwoeburVJyHflC466csaP+BoeWdjVaNbp3JTuRuRYMQictMcSorpMag
         R1dNsgsq5ir1gjTI0K6LthtVqG+jqbLBl5IEeku+Su7R7XVEPBIn7xHgPSGs9l4PEttU
         ZUww==
X-Gm-Message-State: AO0yUKVFFVq/SPOHa+QFIguMeBtdr8BtxOb+boWbgMKAkKp2rhMxY+tY
        C1zWVPfe9vBNhsut0hSiuSA/+g==
X-Google-Smtp-Source: AK7set8fHQLG5Nd+icRsocIidKm+M6XFbKnc/yZTeHH2cRn9G0km1u5/MmvSIXKlObjHB1AdICgAdQ==
X-Received: by 2002:a17:902:e744:b0:19c:d169:cb3f with SMTP id p4-20020a170902e74400b0019cd169cb3fmr3923875plf.21.1677878654547;
        Fri, 03 Mar 2023 13:24:14 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id lg12-20020a170902fb8c00b0019ad6451a67sm1958466plb.24.2023.03.03.13.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:24:14 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:24:10 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 6/8] KVM: selftests: Hoist XGETBV and XSETBV to make
 them more accessible
Message-ID: <ZAJlelPsCrraF3aN@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-7-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224223607.1580880-7-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023, Aaron Lewis wrote:
> The instructions XGETBV and XSETBV are useful to other tests.  Move
> them to processor.h to make them more broadly available.
> 
> No functional change intended.
> 
> Reviewed-by: Jim Mattson <jmattson@google.com>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
Reviewed-by: Mingwei Zhang <mizhang@google.com>
