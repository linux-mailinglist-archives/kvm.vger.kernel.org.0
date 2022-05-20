Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECA052ECE5
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 15:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349636AbiETNMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 09:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348037AbiETNMP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 09:12:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F214E146745
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653052332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+5nV8tCQI3oqLbTA5SCZ4g2sr1Sj+tUNQuV71eHdmE4=;
        b=InWyXs3PCARcrAEfBy2+lK1FQ6UVFqjhq+OvkixwhZF33M4LwcFoLHPe5JzIi0f0gS5NJ5
        uiBb/mX6OnUZtWdAO48UWBhoCf4m1PjhWKzjPY/y7P7fdD0j0U5xZaej6oRbI4LqI4ETpc
        TyNE4O+qlKTPYnfdmYDddYPoXqwxKfs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-EGeomIC0NWaDhwp-P0xpNQ-1; Fri, 20 May 2022 09:12:10 -0400
X-MC-Unique: EGeomIC0NWaDhwp-P0xpNQ-1
Received: by mail-ej1-f70.google.com with SMTP id bt15-20020a170906b14f00b006fe9c3afbc2so2335548ejb.17
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 06:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+5nV8tCQI3oqLbTA5SCZ4g2sr1Sj+tUNQuV71eHdmE4=;
        b=zbsmtxb4JEFtqLjkv0GLhfwJAA7G/FPB8/DzE7hFPWYxl0n691YNhRvAQ5qfLbJaek
         HtGWVH9qqWmKkwKWgdfH6FWJrIYCcKCpQ2hS4JlzBjN6iHDTPuoZDbViX0JMYJucBTSn
         3oBtmjQpixORFSdFGs6S/NcGbCNiA4O0JdX/mfajbxDt3QhwEvIIaNmYXBeUQYq5NAtU
         UhXcX3WO07MChIRy8X6Gifqz5U7f+eblA2ZRRCtfqcpR1B3Vx11NqvijO9LAZXU9agFN
         +WFWxU66SPQwShoR2EoIn6X0WRAH3B0AT+sgt8G2W9jeha6Frx94Eg6fu6jmoGIiUtFJ
         oe0w==
X-Gm-Message-State: AOAM531V0OEHfbUA0/lmGgBajGeD94U9iv29I5QaBeZGA/EEeguphgul
        p8V1PoCM9xFD72944ahClYtQPvJiuTo4rAZL9eqBDlpAdJgjGHdqCYoiLwoXF6oZao3cevEw014
        WQBcZEsAPldew
X-Received: by 2002:aa7:d38f:0:b0:42a:a2e6:90d9 with SMTP id x15-20020aa7d38f000000b0042aa2e690d9mr10778437edq.305.1653052329607;
        Fri, 20 May 2022 06:12:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmoF0iLvTnkJ3kfMJRJlyQ7URlnlSbbkLWcwjOQ/BNEHsnsipIq7G5N/8XON+tREjWiZe6dg==
X-Received: by 2002:aa7:d38f:0:b0:42a:a2e6:90d9 with SMTP id x15-20020aa7d38f000000b0042aa2e690d9mr10778421edq.305.1653052329465;
        Fri, 20 May 2022 06:12:09 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id 1-20020a170906004100b006f3ef214dc7sm3114291ejg.45.2022.05.20.06.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 06:12:08 -0700 (PDT)
Date:   Fri, 20 May 2022 15:12:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, thuth@redhat.com
Subject: Re: [PATCH kvm-unit-tests 2/2] lib: Add ctype.h and collect is*
 functions
Message-ID: <20220520131207.c36niz3enmtssofs@gator>
References: <20220519170724.580956-1-drjones@redhat.com>
 <20220519170724.580956-3-drjones@redhat.com>
 <21a2a499-a61b-8d25-92c6-c91e6d5ea2f9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21a2a499-a61b-8d25-92c6-c91e6d5ea2f9@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 10:10:14AM +0100, Nikos Nikoleris wrote:
> > +
> > +static inline int isalpha(int c)
> 
> minor nit: I think there is a trailing whitespace in the line above,

You're right and I've fixed it now.

> otherwise:
> 
> Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,
drew

