Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46B874B2F9
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 16:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjGGOVH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 10:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjGGOVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 10:21:06 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C81C10B
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 07:21:05 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fbab0d0b88so27236485e9.0
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 07:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688739663; x=1691331663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hQBjEmqWumHRJOwGmRc4u2Rx6b5L1W5ad2b/MItJISs=;
        b=JRsDTimzGEnst+K5Pe1ImCGKug/MQXrealtCpg/X8+GZGxvE1lG1AVEt3GVGvZ8rN6
         83jsN/xG/65BtmpjQzUcnN54s+8kCj91QaNlWKKb4GXNW86T7FFrtwqed6SEtXBzyplz
         HHZ8paZ2WWkJmS5M1gcJEwsKsf3/2eeoD/AhXTsNSaq49w9jkiVUuwi3MFyHj8gBBR2Z
         PJwnj1uBmCKCkS9msxfHz+Se0lRKJQKjduKCNDVCDFXtS6GxOr/P47bJGJEYPP3avfUk
         VIkx5fRb+easTXqU2IFXyGIVkDYmqs7149PP/kykfHc6WJ+6GDzQxhzSaLcRokgiQoJW
         LQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688739663; x=1691331663;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hQBjEmqWumHRJOwGmRc4u2Rx6b5L1W5ad2b/MItJISs=;
        b=M5f16Y8PcCmjl/z4g3KejMkJclk/GVxW7vhB2IdgBPO8XRRJrqvEci4d5CKE7u4Utx
         Wgm+to9hL3Yu6ZGSzweq8eNd89DSSEq+pSgXyEAlQJXZDnGCHpk0qyKSfmp/tsV6Sndb
         XZ7ArwUwJL8q3/N5Q3RHxnRdZ1qJYb7R0E1/1XzDxb4SY7uKeo9FW+2aJQdVJ9TecsTA
         9chI3Rmr3HDEKZ59dOeLjc65ZqPlMDgWXmfw49Q9nUh9oQYZWsqIZfLnWpVR8nOMM9Tg
         zSDW38hZvU2TrHcAJX6UQzlNFeKhOh/JZHgd9v0vvpb7zE1w+EZg9Q3q2jOneWkMgAJL
         +KuQ==
X-Gm-Message-State: ABy/qLaPo8jBd223my/gpKtkUrK9pvFwKFSbB7oAZmoUd7AtrSV1d2t8
        LkxO6S13T/0NTAvjAUMDxO2CNRDkYk3H4h1r7o8=
X-Google-Smtp-Source: APBJJlHvldcnGWXvilh+EXUeZJfOga4mh9j0ORQwBe4e+oOCyrMGa7qC0kIy3Aft+hAC1Rr5sE358A==
X-Received: by 2002:a05:600c:3c9c:b0:3fa:91d0:8ddb with SMTP id bg28-20020a05600c3c9c00b003fa91d08ddbmr8374768wmb.14.1688739663574;
        Fri, 07 Jul 2023 07:21:03 -0700 (PDT)
Received: from myrica ([2.219.138.198])
        by smtp.gmail.com with ESMTPSA id l22-20020a7bc456000000b003fbb5142c4bsm2600215wmi.18.2023.07.07.07.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 07:21:03 -0700 (PDT)
Date:   Fri, 7 Jul 2023 15:21:03 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Suzuki.Poulose@arm.com, andre.przywara@arm.com, maz@kernel.org,
        oliver.upton@linux.dev, jean-philippe.brucker@arm.com,
        apatel@ventanamicro.com, kvm@vger.kernel.org
Subject: Re: [PATCH RESEND kvmtool 2/4] Replace printf/fprintf with pr_*
 macros
Message-ID: <20230707142103.GA4060098@myrica>
References: <20230630133134.65284-1-alexandru.elisei@arm.com>
 <20230630133134.65284-3-alexandru.elisei@arm.com>
 <20230704094636.GC3214657@myrica>
 <ZKgTKGgUtszsK0EM@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKgTKGgUtszsK0EM@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 07, 2023 at 02:29:12PM +0100, Alexandru Elisei wrote:
> > > -	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN)
> > > -		fprintf(stderr, "KVM exit code: 0x%llu\n",
> > > +
> > > +	if (current_kvm_cpu->kvm_run->exit_reason == KVM_EXIT_UNKNOWN) {
> > > +		pr_err("KVM exit code: 0x%llu",
> > 
> > Not your change but 0x%llu is wrong, it could be fixed here
> 
> Not sure what you mean, hardware_exit_reason is an u64, and it's cast to an
> unsigned long long to avoid printf format specifier warnings.
> 
> And as far as I know, unsigned long long is at least 64bits according to
> C99 (the only reference I was able to quickly find is LLONG_MIN being
> defined as -(2^63 - 1)).

Sorry I meant the 0x prefix is wrong because we're printing a decimal
number, not hexadecimal

Thanks,
Jean
