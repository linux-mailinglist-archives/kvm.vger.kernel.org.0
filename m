Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2703A3445
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 21:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFJTtX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 15:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJTtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 15:49:22 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF44CC061574
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:47:09 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id h12so2499738pfe.2
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 12:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1riA2amXnwC2QT35mVQ5QFxvx4A6tenDjIbnnUpEvuM=;
        b=KM/C4DJcsRXXxxiqObrs2HaCutGBRssCSphexck+IF/i7F6izF3Qq/tU7FbecSuzgP
         lZIDfkGxK3MJEsWkpkmJkMHU9BpEgtlIALexAScNb9jPVogYqZZWmGSDIC4/D+T6dMVZ
         Ooal/oWYhZG9FX9bfEBKSZtMEFXaAO04pJdB/pEJiVBPkkvBwATheFhom55lo8P0H4vL
         +d1NFn0OljDWANQnj+DTuett6lJjF9GQoAWE0uKxN3/erm6apHFkO19Y7ad0KgJnt+HA
         2VjAIGVZMy/tk88wAOB2ovc4oNpjrQeN/fpq6VWPOoH04sAfLewGIWQGvRkOo17pwjHH
         vYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1riA2amXnwC2QT35mVQ5QFxvx4A6tenDjIbnnUpEvuM=;
        b=K4K+ISYW9W6XU8tRWQiyUidh3ilkRUH8g+PERAUU7FI9PivI9z+3aMi9Uf9KTDWBhz
         8OGR1Bo41MxAwwvH/uztoUTUNqfE+S+i9gDYgf1ILGTnNQoE3AqqzmvY3ug18zNp8xgB
         vTpyuOTzr8tTOECZekDiMewfV/UF9pnAUGaus4PYC7xIsjeRJTwajFnE9oGrWpGVKac3
         32B6Zghu3YV0wMBAJU3uObx4+xPgC45RdEWNFhjIB7kItx4wsy+w6gmt/qxzY2MDnmrU
         6+q7fytm9Gowa/CtmM8a5mVnVIubNmDfPgqzvXf0rznXE65i/JcXP/dVQK3VUMc6iq6p
         bedg==
X-Gm-Message-State: AOAM5326GRwHr8QD0wnbHexUZyDdtl1JJW+3xCkNgr/7s2Yy87I4nAHb
        MzqgbJblODBvcw5etIpwHgA4LQ==
X-Google-Smtp-Source: ABdhPJxNlTWRsUwcfOKSpSAmQxfeUV7yFXAa/M2OS/GpoudIhUXco0Fccs+9RRjwPblPPCQPu+edyg==
X-Received: by 2002:a63:7a01:: with SMTP id v1mr32520pgc.307.1623354429290;
        Thu, 10 Jun 2021 12:47:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x6sm3040429pfd.173.2021.06.10.12.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 12:47:08 -0700 (PDT)
Date:   Thu, 10 Jun 2021 19:47:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: switch per-VM stats to u64
Message-ID: <YMJsOXtpU5hU2nc+@google.com>
References: <20210610164638.287798-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610164638.287798-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Paolo Bonzini wrote:
> Make them the same type as vCPU stats.  There is no reason
> to limit the counters to 64 bits.

s/64/32?  Either that or I'm worse at math than I thought.
