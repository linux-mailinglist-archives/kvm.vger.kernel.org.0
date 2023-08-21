Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7C378366E
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 01:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjHUXk5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 19:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjHUXk4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 19:40:56 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BFD129
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:40:55 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-56a9c951aaaso991221a12.3
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 16:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692661254; x=1693266054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6hxKzHgi9d4WPNv2P8i1Clv5FBV0aYf+5QTFaoJOKk=;
        b=sk5mVdY6GWxrrtQwwPVcYxuEmc1edYyRX+zvRiMit6+uyM9i726aGsNOQQ0QU1JdD4
         E9Wm8hbt3eTmiOtuXITNI0+TvNOnUOYIh1gIBCYt3s4tQxygxRiu3KwW95uuIcHdY9Mc
         JkAECHU64nuxaGUWHylFCHHGo1z6slbo5CHFoGX3Ff1bgi2y5R3HlBS1+KUhZ4Urb4Dw
         xG1FAbqEMbnPJJhe1pdbVI/hXNoKhg6+tnIEQJyOSmHbYL/5dZPo/N65bwmrRe4J/XjQ
         Cyk5dyRxYqdHELgx9XObPurh0aPW6orSdXRsOAzRjZu77c+RnOLVRbDF4nIRzK7x7Dyy
         hYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692661254; x=1693266054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6hxKzHgi9d4WPNv2P8i1Clv5FBV0aYf+5QTFaoJOKk=;
        b=G8Eo1pgEknPl2aEY6K80yiLCig1IdQ3DXSbW9tmzG2jU5nlW0N2EEmqCwKnvUpqF6/
         Z5+E4LFYoOHQtpreAeAkMRHvzm+U3An5eKchvgnMG8dQwiZtbv4A3QjVlodA8rMWg8An
         GUGi+KfjEJ8kqB92OW7vzvH2vJn3vzYwLeilu08qK0KvQG02Pe0gMB/LeWNO1lwY2UsD
         oad+cUizfSLjZ+A8oH/KCyPpTgYY2YwOMszTIKhZ2NIHumH2KNnZO9EZUoGCyKW3PFuS
         SoJS44GvWJXTXmL5CZzvetEVfAoVZ7VxhaskdR/1vx9dSmBfJ811FqczGGGi0wR7eY7p
         U0Zg==
X-Gm-Message-State: AOJu0Yyti50O9tBKa6ODlwBd86NmbH2h5zHLNNfrTyMD73VRZMYDC+bV
        wioAbgOEGDQfiPKFS8Smp5s=
X-Google-Smtp-Source: AGHT+IHtjBCt8jrVzPeTOBdc8g4jdYrRi/zoCQrAC1is1JU64CShTSGPBmOxlMPvGeI26awApkEH/w==
X-Received: by 2002:a17:90b:906:b0:268:a26:d9ee with SMTP id bo6-20020a17090b090600b002680a26d9eemr5094837pjb.46.1692661254519;
        Mon, 21 Aug 2023 16:40:54 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id gl13-20020a17090b120d00b002635db431a0sm6636383pjb.45.2023.08.21.16.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 16:40:54 -0700 (PDT)
Date:   Mon, 21 Aug 2023 16:40:52 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH v2 32/58] i386/tdx: Track RAM entries for TDX VM
Message-ID: <20230821234052.GD3642077@ls.amr.corp.intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-33-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230818095041.1973309-33-xiaoyao.li@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 05:50:15AM -0400,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
> index e9d2888162ce..9b3c427766ef 100644
> --- a/target/i386/kvm/tdx.h
> +++ b/target/i386/kvm/tdx.h
> @@ -15,6 +15,17 @@ typedef struct TdxGuestClass {
>      ConfidentialGuestSupportClass parent_class;
>  } TdxGuestClass;
>  
> +enum TdxRamType{
> +    TDX_RAM_UNACCEPTED,
> +    TDX_RAM_ADDED,
> +};
> +
> +typedef struct TdxRamEntry {
> +    uint64_t address;
> +    uint64_t length;
> +    uint32_t type;

nitpick: enum TdxRamType. and related function arguments.

-- 
Isaku Yamahata <isaku.yamahata@linux.intel.com>
