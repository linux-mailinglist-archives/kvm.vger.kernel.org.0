Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944F760538A
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 00:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiJSW6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 18:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiJSW6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 18:58:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A451CCCFB
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:58:51 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a6-20020a17090abe0600b0020d7c0c6650so1627236pjs.0
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 15:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s30qKbBx2V3x7QKaP+ZrJAMYfFU756agbejlsP55pmE=;
        b=OgKqtVMr5aieFWzkGUa4QB5n96tiLMFY4bkp9O0nnODrBUtkNg4TPDQKWpmtC0s5y4
         MZbOMHNCIIzhKoqsZpbQdweyFKwLgZwLlYbVReIyMeBDCL4ciZGzKkbe3qmFdqsPyrDD
         znyiv7kob1JUVtMFP49k1DEB4a05fKdW9IAn+LMICNM/Y+gujETxzD48kw0BPWO6XWRc
         sIFtQItzD/P9NXO+Op/UybjoolLfiBlZ8AH0Bu1GjocgKIBUSpSla78iVMb6Os5/gro4
         hyw2BxYgogXkZYl12kheeFM/zdFILcf27ISd223Mn+drzwmVBYt4PtTRvoXcsEpqnXzU
         mqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s30qKbBx2V3x7QKaP+ZrJAMYfFU756agbejlsP55pmE=;
        b=104LvTWdco9ByXVjsQXhFymRXOsNUGYHmKYgTMblCrG6v+APrpbzFP1eABqT0mXNhg
         uom0ILcLoxNVdr8XKv3qFtfbcRlLgB0bzfjkmJEEW5jg74US8YQ+GhYqrDjWacaSngZQ
         eJv0w3CI5xeGcDm4c7VI5BnU1euG5Ggxi6sXhF38qwCS4Qd0UM83Owlma7PBeapoKLDE
         TjR5eKU5c9oPOSLQ3vLgXVzs6VebSFIS1g2+qU2BTp8Nt7aroEQxES/1nn2GFi60TIth
         oz7NiQYJAD7uwf2X+SCO9gCwFqAEIEkBIoxj/+/q+uvhV8jLKb+kTZsVBPbX/ljMtexU
         p/HQ==
X-Gm-Message-State: ACrzQf3UQ7oiksLx4vUlZfrZk8WJqwAivUzQ14iOdD1lZi4W9uYlMv8p
        3Ow7BvfRyTHTOv4QXyDNh+o1qw==
X-Google-Smtp-Source: AMsMyM7YImNJMxhLkMeY/kM1No6joH/l21CrCqvPigwhBsLzj02MYrZuOp564XMMC8DXrYCy9CNL+Q==
X-Received: by 2002:a17:902:d349:b0:186:5d53:b230 with SMTP id l9-20020a170902d34900b001865d53b230mr3178322plk.106.1666220330038;
        Wed, 19 Oct 2022 15:58:50 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i19-20020a63e453000000b00434760ee36asm10208604pgk.16.2022.10.19.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 15:58:49 -0700 (PDT)
Date:   Wed, 19 Oct 2022 22:58:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/6] KVM: x86: Mask off reserved bits in CPUID.80000001H
Message-ID: <Y1CBJT9MhpYEB586@google.com>
References: <20220929225203.2234702-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929225203.2234702-1-jmattson@google.com>
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

On Thu, Sep 29, 2022, Jim Mattson wrote:
> KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
> actually supports. CPUID.80000001:EBX[27:16] are reserved bits and
> should be masked off.
> 
> Fixes: 0771671749b5 ("KVM: Enhance guest cpuid management")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---

Please provide cover letters for multi-patch series, at the very least it provides
a convenient location to provide feedback to the series as a whole.

As for the patches, some nits, but nothing that can't be handled when applying,
i.e. no need to send v2 at this time.
