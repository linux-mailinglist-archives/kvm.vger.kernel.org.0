Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBBB59F024
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 02:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbiHXAUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 20:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiHXAUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 20:20:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EADB6560
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 17:20:07 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x15so14079464pfp.4
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 17:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=AexJUaArVXuqWOH1RZOdaYZi2eTtx+LWlNQw/hI4Q8M=;
        b=pplYmMWmQZ2vjkzy3s/eVUyfXBanDHqIcNON0f+DrlB9QlJ+dHjqNUZH1F8BxkirF6
         Ie3Lkqg4WC2jz4WQLbpxvtHWNdWBhxp79sn1nUL/1dItfoezMw41om1VImQEr6T1KxCI
         bH6aAVygrklDnL/3ygwaNXfdhPDl8kH+sn+/GIa6jdt+Qq3En9PEVNCPBf+F+1jp/+Ll
         RdGvOP34yZ7kscR8VAUMbT0GsVat9SSQX+CPNs0jdutXr8S0bDU+3WMg6zKC2s78Tb3T
         LYDn3PB9F3zgSy3KnnlePMwJ4QhOTE9MDZM3ZMe0mjlwtYYejPKhrHhLDgB9/YDx3Pyl
         fK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=AexJUaArVXuqWOH1RZOdaYZi2eTtx+LWlNQw/hI4Q8M=;
        b=6rYWAUvEsWGiczpCEx68vUrDW5DYtbhzpQrSEFMii3Sv8pZqM26CU+1OvK2mE64b5m
         3MkBZ2sdJtWF96JPH8T6jW2rVeoxzPwA8HxEvSl7SqBCaqaShLjnGUpIm2MHoNaWtsVe
         /zzd6hTpfYgy8XxZljsI1iKO1Se9h1Wk0sfaRwdt3GR6ZhMjjucK7oIXIO7u3OXBkd0H
         64EJKMgviZgAarGsD1oqz1dbAyrj1LLiGvpl7eUqKf325I8H8McjzSLNJbMULZjX47c8
         Vm9l+hWTMcrg2rnn3TiS4P6Jx9fGlmWPCnNp/klTpM39ABcfUnluO863GHJLbJV166q2
         5Jig==
X-Gm-Message-State: ACgBeo3wfDSrUulDK+1hfDzw6/B1oULiHVmWQtl1X/PAZ8A8Ldcgh3ha
        s5K9lgLwNNZvNlUpsdfugYcfZA0f3vpClw==
X-Google-Smtp-Source: AA6agR77UGHQ2AM4HcP76QnNVgAJtY52B6WaL3aXvjHBOoki4h6NvlbEZd9umQpSRUBd2k74unJ/dQ==
X-Received: by 2002:a65:640a:0:b0:42b:39a:4ae9 with SMTP id a10-20020a65640a000000b0042b039a4ae9mr2718838pgv.179.1661300406951;
        Tue, 23 Aug 2022 17:20:06 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y4-20020a626404000000b0052c87380aebsm11378371pfb.1.2022.08.23.17.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 17:20:06 -0700 (PDT)
Date:   Wed, 24 Aug 2022 00:20:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Michal Luczaj <mhal@rbox.co>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH] KVM: x86/emulator: Fix handing of POP SS to correctly
 set interruptibility
Message-ID: <YwVusiSjT8xINz2q@google.com>
References: <20220821215900.1419215-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220821215900.1419215-1-mhal@rbox.co>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 21, 2022, Michal Luczaj wrote:
> The emulator checks the wrong variable while setting the CPU
> interruptibility state.  Fix the condition.
> 
> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> ---

  Fixes: a5457e7bcf9a ("KVM: emulate: POP SS triggers a MOV SS shadow too")

and probably 

  Cc: stable@vger.kernel.org

even though I'd be amazed if this actually fixes anyone's workloads :-)

Reviewed-by: Sean Christopherson <seanjc@google.com>


Paolo, do you want to grab this for 6.0, or should I throw it in the queue for 6.1?
