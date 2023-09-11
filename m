Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E85279BD7D
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjIKUtV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237293AbjIKM2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:28:10 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3134A1B9
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 05:28:05 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-41369b80875so19442661cf.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 05:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1694435284; x=1695040084; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zn0VPuMCaZZ/Sf/x4SYpp1ksKQN06bPb7JpCjgEI2sE=;
        b=B05FJTJUZo5uh7ARxi2MN21gm18GqcbV2vFpeMM+EIaf7tjg8rJW0s7PQ7/2mVxA1T
         ELzKGDeDQ5xd+1Mumw0N/APzXyy78EkvlbARtR6Xr4P8xeyDjgSP6I9aXrcNYQdi/+Q8
         Ohg4rUkQ79eva4bNcwZxphmqeczHPlc66aVjgDe1t/2MCFnC3p1eDyHHRHOC73NJAXHA
         dTu2ZT78jOjBa0i3s8MxS450KFKqMur8nfrAFwWMnGSmhDmkF5JL7EwzenP48zpmOrlj
         bQvb0BLfFgSUZW2MjsQQteMN/DAQKyr3v6O2mlD4k1nX8Vbr6435Eq2eRf4XDpTIySXG
         KiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694435284; x=1695040084;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zn0VPuMCaZZ/Sf/x4SYpp1ksKQN06bPb7JpCjgEI2sE=;
        b=YR953+uWd6vkWRzwTiLxuPUbfKjY7mtHT4a5QcGbXbkU7Zd3x3btuxajo09YyRs7Eq
         vBE64o10UCpaT9UOueBC+Wros5i+VUhojny41zsfjdZvxFJIvkJ/sQPPgWz5kQFeImkm
         9METFmf7Ei1mA4DT32j1ad7CJkpvvJq0M7v7FuygdD97K9g9wH2VtwntwBJART2tdrAs
         zPWAEkRHmTuwK5kSebiFBwPsHN7YrFakOGTICnULe/gp2DkyVJ9qmVVpj2n8TE5ezSrs
         AOlolrlNHaVvUgfbswNwgIvmsyBlMhwc17oK7K51gpIisCAn/IxucnRk3NcVcjH7tMbh
         HQ5w==
X-Gm-Message-State: AOJu0YyHDjX9cpkCWN+L+LMb7Fppfa4+ygCLxXB318jywkjiWnMhyY4V
        fp2dSC//87CuwFrW5ucAVPoR7w==
X-Google-Smtp-Source: AGHT+IEuiBqhh8flWvXQjI9qVYyi7SQ+iMh9AbQCI6PHKvz8gvU9yEMKJFwQ3Xcbwzjo+nZxgEPrMw==
X-Received: by 2002:a05:622a:2c42:b0:410:92ca:3dcd with SMTP id kl2-20020a05622a2c4200b0041092ca3dcdmr11567113qtb.9.1694435284073;
        Mon, 11 Sep 2023 05:28:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-134-41-202-196.dhcp-dynamic.fibreop.ns.bellaliant.net. [134.41.202.196])
        by smtp.gmail.com with ESMTPSA id ih10-20020a05622a6a8a00b0041072408126sm2559963qtb.5.2023.09.11.05.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 05:28:03 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qfg1K-001XgC-L8;
        Mon, 11 Sep 2023 09:28:02 -0300
Date:   Mon, 11 Sep 2023 09:28:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     oushixiong <oushixiong@kylinos.cn>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Brett Creeley <brett.creeley@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/pds: Using pci_physfn() to fix a compilation issue
Message-ID: <ZP8H0puYJeYF33fn@ziepe.ca>
References: <20230911080828.635184-1-oushixiong@kylinos.cn>
 <BN9PR11MB527657CA940184579FD31CAC8CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB527657CA940184579FD31CAC8CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 11, 2023 at 08:25:18AM +0000, Tian, Kevin wrote:
> > From: oushixiong <oushixiong@kylinos.cn>
> > Sent: Monday, September 11, 2023 4:08 PM
> > 
> > From: Shixiong Ou <oushixiong@kylinos.cn>
> > 
> > If PCI_ATS isn't set, then pdev->physfn is not defined.
> > it causes a compilation issue:
> > 
> > ../drivers/vfio/pci/pds/vfio_dev.c:165:30: error: ‘struct pci_dev’ has no
> > member named ‘physfn’; did you mean ‘is_physfn’?
> >   165 |   __func__, pci_dev_id(pdev->physfn), pci_id, vf_id,
> >       |                              ^~~~~~
> > 
> > So using pci_physfn() rather than using pdev->physfn directly.
> > 
> > Signed-off-by: Shixiong Ou <oushixiong@kylinos.cn>
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Yes, we should do both patches

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
