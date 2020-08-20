Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117DC24B01B
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 09:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726309AbgHTH0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 03:26:45 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60297 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725819AbgHTH0n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 03:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597908401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=moE59twGHKI7k28SZAbOSnFimdPydL4GY9WfrG5itmA=;
        b=E2vvJ7LKRjYDRA5wQTFpsskmrv6cwSNjACl1Lx8rq40Vn/uo6BYTgDYD6lAjPKDkkFHRX9
        lXu+B4pJU2ycdr6lPcUCdt2I2guwpZsc2kvqoIS83sht2GB5q9KiY7oDZdx6WgE59hljJr
        XyBLqB2hPvsxaTNw78b0MHhWDXojdGM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-twgoU8QrNea8r4YJm-GL1g-1; Thu, 20 Aug 2020 03:26:39 -0400
X-MC-Unique: twgoU8QrNea8r4YJm-GL1g-1
Received: by mail-wr1-f71.google.com with SMTP id t12so330325wrp.0
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 00:26:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=moE59twGHKI7k28SZAbOSnFimdPydL4GY9WfrG5itmA=;
        b=F3vfNlsoOtvf+Hx6Qra/CkmmAw1chqV5Di4UwnO2Ny1Utd5wNBpLwU3mnlp0XLptX5
         WsnUD5sua4o7iUmrNakSYzmwWmzw49bAZkYbjp1TASYNZZrPDAlOTTNl8JeKooU1ZKrK
         5xmk+TVQ0qyBe466KqlqavKrI50xFVHE2COQIvkLIql0s7HmTa13Cd0hcLiFZ6Vu/6eP
         gNPmhjaK1N/8nXcUQ6uomKaMc5DBtuy9mBRyFv8YcUZ8qTsuP6m2tNvdSXtOuMnWSCkG
         0X1g9WOwJoyBWmjgB5wdcJxrxUyvXHvJoW0z+wZdR2rMoamXibSD7CGMuqzjsDl2wFrO
         QFUA==
X-Gm-Message-State: AOAM532ZY9IuULhZX6y+HCE98PddoP2SSMR+r0H3BrEMDhQ2mGatRqU1
        dvPYSq1cvTV0zPlRQqwR13Y5jtFxZkQzqQUF9kYvAT/hM0sY2g1aUGEzObdBKaCsVJXOiEW6XYm
        1yOhqBjcXYKFc
X-Received: by 2002:adf:c789:: with SMTP id l9mr1888089wrg.41.1597908398517;
        Thu, 20 Aug 2020 00:26:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBwwkk+81R0CeVuNZYFZ/H/Iy/w3GMsVNOB7/445m84umm/A6fxcrBYXhG1+K6mO8XKIcRQA==
X-Received: by 2002:adf:c789:: with SMTP id l9mr1888078wrg.41.1597908398316;
        Thu, 20 Aug 2020 00:26:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id p25sm2494328wma.39.2020.08.20.00.26.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 00:26:37 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: arm64: Fix sleeping while atomic BUG() on OOM
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200811102725.7121-1-will@kernel.org>
 <ff1d4de2-f3f8-eafa-6ba5-3e5bb715ae05@redhat.com>
 <20200818101607.GB15543@willie-the-truck>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3c579063-7ce8-cba6-839f-01e5a46a7b94@redhat.com>
Date:   Thu, 20 Aug 2020 09:26:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200818101607.GB15543@willie-the-truck>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/08/20 12:16, Will Deacon wrote:
> Please note that I'm planning on rewriting most of the arm64 KVM page-table
> code for 5.10, so if you can get this series in early (e.g. for -rc2), then
> it would _really_ help with managing the kvm/arm64 queue for the next merge
> window.

Yes, I plan to send it tomorrow.

Paolo

