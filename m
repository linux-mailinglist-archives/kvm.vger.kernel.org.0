Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38E5E6BE9
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 21:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiIVTlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 15:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiIVTlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 15:41:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE1710975F
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:41:16 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3232026pjd.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 12:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=RYB6BGJvPvJGjlYGwc1124XJvSRMSlT6Ie4vSqCbQu8=;
        b=NXNO7E7T+Eyi3WutyeW9ldUi9IoU9NNBJMhaTF0dVVd0vk8qpu3V4Gk5o1s+REoJBv
         nMcvvb/RC6hRdTTXC9QTfK5ElqaoOjz91EccsETrFSLv1bmQsdZUJgaxtuXU3wRMTTWm
         zXcAb3TAUVeLw9qFSdkggVM7eoBeTibVNtY9ZSSGm3JgIosnbXWMF8r5eiHxPL7pcz8W
         FwDTQyPQvJWznbCcE0gTCQFaH9jYKKyQcuYpwD1OtQYoAJmuS/QdQHdbkTsLgpji8KVI
         qnGEAytavQzjikZ8+gL8CInhjTbDuHOJeDGw5aYG22h7QJX7FS2L1/FkW09VAtxFQ62l
         oHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=RYB6BGJvPvJGjlYGwc1124XJvSRMSlT6Ie4vSqCbQu8=;
        b=pQUZrQbaJEWN5KqpLG4qoVS557R78aUxjALtEGinbDflzftQCnY6Gq3Jg7dwCV4le5
         ixSHXhTZO6ksNwN7nbr8u6yjHF+qBztBY5v5dxuQe8OsBJ45s5Ch5wse/RajtVO7RQ2I
         IX+kBi8Dh2zIAzRyQhlRS1RuNuW5NYkqHKg6ACc9XPZ6Ns55r1vTfMLPVrF3k97HmmaF
         9k0dHohx6tgKuTeIy5GBYXrC8ltBYFpf2d4Lo1v4+EMT8wAzphL1xvkZRBn6ya7Fayyq
         44Po0jAAVmk0uM/ioYvpIctm6yJDajt2fYTgSgBzb0nuj7w7/s1rTszop7Uma28Rgnqm
         TsrQ==
X-Gm-Message-State: ACrzQf2dEHvw9Sznbt2fFhni3H3jk/HMHVVwOItdiEjF6Xvu+YlteBPa
        68MQvv9AQF9Ta1UJsXJB6wqQig==
X-Google-Smtp-Source: AMsMyM6XM0Ni4PvQQLJgk+M0su4MCNPn4YnN2e4DGaaMICBByIDPbg1bMi1yQ96V9IntdeRL18JRlA==
X-Received: by 2002:a17:902:b194:b0:176:d229:83bd with SMTP id s20-20020a170902b19400b00176d22983bdmr4740841plr.174.1663875675538;
        Thu, 22 Sep 2022 12:41:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e5c800b0017300ec80b0sm4618456plf.308.2022.09.22.12.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 12:41:15 -0700 (PDT)
Date:   Thu, 22 Sep 2022 19:41:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     cgel.zte@gmail.com, pbonzini@redhat.com, shuah@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmatlack@google.com, jmattson@google.com, peterx@redhat.com,
        oupton@google.com, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] KVM: selftests: remove redundant variable
 tsc_val
Message-ID: <Yyy6VxMhhua1mj7P@google.com>
References: <20220831143150.304406-1-cui.jinpeng2@zte.com.cn>
 <b9044b55-1498-3309-4db5-70ca2c20b3f7@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9044b55-1498-3309-4db5-70ca2c20b3f7@linuxfoundation.org>
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

On Thu, Sep 22, 2022, Shuah Khan wrote:
> On 8/31/22 08:31, cgel.zte@gmail.com wrote:
> > From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> > 
> > Return value directly from expression instead of
> > getting value from redundant variable tsc_val.
> > 
> > Reported-by: Zeal Robot <zealci@zte.com.cn>
> > Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> > ---

...

> My understanding is that this patch isn't coming from individuals that work
> for ZTE. We won't be able to accept these patches. Refer to the following
> for reasons why we can't accept these patches.

Ouch.  Thanks much for the heads up!
