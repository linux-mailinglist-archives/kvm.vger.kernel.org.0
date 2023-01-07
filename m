Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09010660AF8
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 01:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235686AbjAGAj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 19:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236975AbjAGAjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 19:39:08 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5D6F6A
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 16:38:27 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so6950805pjq.1
        for <kvm@vger.kernel.org>; Fri, 06 Jan 2023 16:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Az0qbuGhzUF6/c9xF1ibfH/zmAl5QFNFCQ09j3R1NM=;
        b=RUidCU79TX7LD2hTeNIuTZ73thDpc6w+rl1bOJzc/cjaokhtx2Y5TNGkKimSo8X42O
         AgkU1CyNspDUHy6vkL6UER5vdp2gS7Ifs+8W/DzLIj8H28317bqDXUo1FvOpY44y8BUG
         aa7j+oa5ym145t169Xg7dCuB54MWzffaRo69MkTTAU3/DNZv3eiJIpMPRSAwox1AAEb7
         ViZao1eaQk4oN6zp4qIheuaswu14+f0W2fHdoP3v5v33pKn43jSs7IIi23JBrKW5f+IF
         Wr84J+jaDERmEN/KnT0QtK1WxV9cHR51vz2L4EyQK4c7BezQ+O5++BcdU+NFwNmsiApp
         HnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Az0qbuGhzUF6/c9xF1ibfH/zmAl5QFNFCQ09j3R1NM=;
        b=dwF4LT69dtZbZuj25C/gXcgvVj0AHIi/ySmIBQjGY3955LRBSbSA5hWz59tlB1Sr87
         2lJ45ud16xjy+ZbbQhYIQrbDjQRFNVcbJFW5iQRVbxV4EqAVsnr9awq48pNVc9MGeU7V
         UPdw0lZy3Ro7LQtOQjPlmsyoyLNlBr5ZL5ioKJgAPf3HIPcFlxW2fPxOyd1dL3sEv+gP
         RU85QzcoEWXbv4l+R9Q+Wlwpj5u3cOA1UTf8LceusUOhlHT2vWG4Eta8me7dZYXqwVpB
         dFLNoAiO7FCp6qrWGHJQTTraOZ0UXRwRO49hfFqNBFcwKivCFTh5TNxaeMjV6fjh2fSy
         sUtQ==
X-Gm-Message-State: AFqh2koxZEVd+AArKFeyhN+VrI7KD+G+8SUdC/KC6sIbJ5A0X8typmK1
        U+/RFw/fz+oT9Le3U+0sRmGt/A==
X-Google-Smtp-Source: AMrXdXtNB0pR8jILzoi99KJKhdNRnff/7CQiMql1LHKfz/k9+UarJtp9aF2Xp6PSm2u9sEdk1ZdPCA==
X-Received: by 2002:a17:90a:98c:b0:226:ec1e:d0ff with SMTP id 12-20020a17090a098c00b00226ec1ed0ffmr56531pjo.0.1673051907063;
        Fri, 06 Jan 2023 16:38:27 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id gl1-20020a17090b120100b0020b2082e0acsm1474207pjb.0.2023.01.06.16.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 16:38:26 -0800 (PST)
Date:   Sat, 7 Jan 2023 00:38:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org, Jingqi Liu <jingqi.liu@intel.com>
Subject: Re: [PATCH v3 2/9] KVM: x86: Add CR4.LAM_SUP in guest owned bits
Message-ID: <Y7i+/3KbqUto76AR@google.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-3-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209044557.1496580-3-robert.hu@linux.intel.com>
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

On Fri, Dec 09, 2022, Robert Hoo wrote:
> If LAM enabled, CR4.LAM_SUP is owned by guest; otherwise, reserved.

Why is it passed through to the guest?
