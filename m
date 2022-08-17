Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2635973E8
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 18:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbiHQQQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 12:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbiHQQPg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 12:15:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363CBA1D10
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660752887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YdM4kHQtSkRiqBeJJNERoQcyD8v2KLZOZ12Pd7Uk/lE=;
        b=O3oFtDrgp0ANiQlEzwv+S+ZU+OXDc170Zo70N1lo0wNQTlhGpxFJD1ZfJ5Gc9+o6AQgull
        vhWsr9pCIV71MVCsFPXHx4XVLLkyNQgY+nmYsIiw/8AQu8wacfzJyM/qi0Z/rPhM1y59Nb
        W5j7Sh/Vh6WbbJ+Vd6qpnM5Ru0q/3HI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-580-8FITGQLPOd-0PYccuaZmQA-1; Wed, 17 Aug 2022 12:14:46 -0400
X-MC-Unique: 8FITGQLPOd-0PYccuaZmQA-1
Received: by mail-wm1-f70.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so6476427wma.4
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 09:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=YdM4kHQtSkRiqBeJJNERoQcyD8v2KLZOZ12Pd7Uk/lE=;
        b=qqPyIW9uSvROepEcED8onLUlbHsOqtJFMcH3mCS5nMfglrlMqowiq6FUVh6c0b/xmu
         o2j2Ym7cU0sN8I85IN34zKbV9oeObdkq8u8s0TTMKy2iMgzjwPbwsu5zp2/hEvU2YFeZ
         1In6G3IyoCBhl/7UN9G7X8tsFUqO4EURbr9EyYCt17FSm0kgdPCVceA55ZOJmh1L4tPA
         cwLWj5nqFV7ej6O8iyA4x3V0JnTvFt22fvysznz8gwUDsacLoh5S4j98cuaEOzrmSCdo
         Sb9WblXt0RJaw+biRV1mGaR0tEQhPN72F3N04YH6zQbE5kY/WPAsMyUEcuJUhEdiuQMp
         D3rw==
X-Gm-Message-State: ACgBeo29JVk5Q5x9nrhCi3i0Z7SIi7YQbL3wGqUkIad7SwWYYcfytQh7
        e+Vdit5izKLtsUmyogyqESVyIFl+uL0rCz8V5AqtFmJl5fh9F7zi2B2OfDyPFniRmxoYfEMoD3h
        7cq4ha8VrhL03
X-Received: by 2002:a05:6000:783:b0:223:93d0:3286 with SMTP id bu3-20020a056000078300b0022393d03286mr14474361wrb.347.1660752885171;
        Wed, 17 Aug 2022 09:14:45 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5dE69vIM/TuWC85NWQRObP4zFra/YXjMzBRsTYnz7YgvqHv3toBl6Lxi9+7i5LNYU4TNPCSQ==
X-Received: by 2002:a05:6000:783:b0:223:93d0:3286 with SMTP id bu3-20020a056000078300b0022393d03286mr14474345wrb.347.1660752884937;
        Wed, 17 Aug 2022 09:14:44 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id m128-20020a1c2686000000b003a5dbdea6a8sm3106591wmm.27.2022.08.17.09.14.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:14:44 -0700 (PDT)
Date:   Wed, 17 Aug 2022 17:14:42 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        leobras@redhat.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH] KVM: x86: Always enable legacy fp/sse
Message-ID: <Yv0T8iFq2xb1301w@work-vm>
References: <20220816175936.23238-1-dgilbert@redhat.com>
 <YvwODUu/rdzjzDjk@google.com>
 <YvzK+slWoAvm0/Wn@work-vm>
 <Yv0TN0ZI0LNFMGQD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv0TN0ZI0LNFMGQD@google.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (seanjc@google.com) wrote:
> On Wed, Aug 17, 2022, Dr. David Alan Gilbert wrote:
> > That passes the small smoke test for me; will you repost that then?
> 
> Yep, will do.

Thanks.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

