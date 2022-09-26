Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1B5EB2A3
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 22:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiIZUu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 16:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiIZUuY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 16:50:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046DB4DB7D
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:50:23 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i6so3690345pfb.2
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 13:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=GaOhE9vDME2PjD2WBLnyx5X63AC8vEuVEpMFFTEj4yQ=;
        b=Ecr+Q4IcXZCPBgp+sjDXwZ65SMQ6bk9vNHxFpN0mZZ2lJTBPO77trLkfQRd4sdyfFk
         TG7/L86ZUDCGFy3xREquepd1gcDqTEJUYG9TG2WdHHvutyfU2rl0yMXmxtUbyg4Qkdxu
         WX4KSOZ7+W3Xg/+efh2vmo58a+dd93KFQYyCqgLYcvHoPcAk3u5PbX2DZDJySmTWjlq7
         8wke8DfCV6dMzMaa3mBRS9GSWEL1ge8B7a6M4+0llXGmzUv12ekNoklo6RAvgeTvojbJ
         AdN8EZ5a3oOdmHvwUwBbCx79kZ1ktbhawdCH2Z+2LUShMzAzswUr//Nn7erTJqd2Kv2V
         QJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=GaOhE9vDME2PjD2WBLnyx5X63AC8vEuVEpMFFTEj4yQ=;
        b=vCcyOLKIFSpeQQr4ajofPS47ojxl5QGHy/kBNK351lNrly4KBVShZNDjD6X4gaQSjq
         9h/reU05oVOhCLVN6zW4CEGW6TiOBKXq4EXAd43A0HMSn8LPbsRstN3qIRl4JxBjrVgB
         eGQJ9uVhHiwzhlfyDlWO8rXG/KsQKpnmwxBvgW+yxahQWAGU5RijRscGWWwhNEfbBYqO
         6zIK8x9H36ib3l36/y6nMwaLhdWN5cBVpvDTSCikUPvu8b4vVFlNA60JAajkKW0DEJs3
         RaK60ZY3NDq2qHF3BTTwGBH9XTa5AERDSYFcRTkXS/MqZAcyVO00E9HKxjTwwAUAOk1g
         kBcg==
X-Gm-Message-State: ACrzQf2l8PC40tEgxodRpfq6TIRBe2/zmH7tTytUCW1LOhC95ejGh1jM
        Gdls4MqXdmiaxQ7ZuF9Jx3SWjg==
X-Google-Smtp-Source: AMsMyM7oYHTETsj+wCwud9S7htfS+SOy4QBAjARrseSiTqXDSVeylYtJ2VhFzgEDHDw/PdyNDk577A==
X-Received: by 2002:a63:4750:0:b0:43c:dac:9e4b with SMTP id w16-20020a634750000000b0043c0dac9e4bmr21593513pgk.300.1664225422378;
        Mon, 26 Sep 2022 13:50:22 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902a38800b00174ce512262sm11503296pla.182.2022.09.26.13.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 13:50:22 -0700 (PDT)
Date:   Mon, 26 Sep 2022 20:50:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86: Pass host's CPUID.16H through to
 KVM_GET_SUPPORTED_CPUID
Message-ID: <YzIQigG1cVLoHQvm@google.com>
References: <20220923223338.483103-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923223338.483103-1-jmattson@google.com>
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

On Fri, Sep 23, 2022, Jim Mattson wrote:
> In the default configuration, the guest TSC frequency is the same as
> the host TSC frequency. Similarly, the maximum frequency of the
> virtual CPU is the same as the maximum frequency of the physical
> CPU.

Under the hood, yes, but after the VM is migrated, isn't it possible that the
host frequencies are completely disjoint from the frequencies that are enumerated
to the guest?

> Also, the bus (reference) frequency of the virtual CPU matches
> that of the physical CPU.
> 
> Pass this information directly from host CPUID.16H to guest CPUID.16H
> in KVM_GET_SUPPORTED_CPUID.

What about "solving" this via documentation, same as CPUID.15H?  If the API were
KVM_GET_DEFAULT_CPUID, then enumerating host properties makes sense, but from a
very pedantic point of view, the "supported" frequencies are just about anything.

Somewhat of a moot point, as the leaf comes with "informational only" disclaimer.

  The returned information should not be used for any other purpose as the returned
  information does not accurately correlate to information / counters returned by
  other processor interfaces.
