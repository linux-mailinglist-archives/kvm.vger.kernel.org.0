Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 306EC5652FB
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 13:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiGDLEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 07:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234108AbiGDLE3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 07:04:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92F6D101CD
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 04:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656932666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KGFeIbWlW1ILCPGgWjFFmuEvOy5XT3e1wvU13U4kX4w=;
        b=fKh8Oegn0uK5I779nZxl59fEoqKtOTTfeL5o033A6sOjHJvPoR3kdxjRcZTCX3z0CF/EYI
        5mLPBntx+axNp+4wfwH1D5JMmTTFsOOq7jwoK4EZKAhGCNU+2ZORubRwmNjaR/zy1cu+ft
        lhwsUDyzI2nwVl6K3zDy1aBhfGV0knE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-AB2iXy1ZP4SKvB00Nb35jQ-1; Mon, 04 Jul 2022 07:04:25 -0400
X-MC-Unique: AB2iXy1ZP4SKvB00Nb35jQ-1
Received: by mail-wm1-f71.google.com with SMTP id o28-20020a05600c511c00b003a04f97f27aso5158286wms.9
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 04:04:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KGFeIbWlW1ILCPGgWjFFmuEvOy5XT3e1wvU13U4kX4w=;
        b=lrTDre9Q4dDR+QmYKKngLKfmzl7Q4sDa3uZo+4YRIwNR6homWH26UEk3v5uCYPnjwn
         WYghWUWXI6AnJIV7MOjxlpM4fL/eqkMrjTnMwkFvLCKOSPjKKHe0O+Xdiibq37oHDCiX
         q1+Oo29Epv3aVuqFnY5tx+pRNaWCl9CIx4Fu/J68ox2dJx0cZ1vDFlZqW9zf6Us/xmA+
         QyH6QBsYXHW8hPYmAETLEPhDMZt5Cqz3r8KejL1fzPa5gQgdeTZa+lz4jlMGMAhtmB8l
         0ZEV2Cq8QNmYEayNHvSlgqfpb/lejYVBJeV1iWP+TtXgVNns3G+ZG5nnxl3K4J4Y/7KI
         59Ug==
X-Gm-Message-State: AJIora/HT/V4CmOAQszDusXBU8Qm28otqwodRRUZ+0Qyq/KsZ5IK/yqi
        J3JNGy9IZZZteUTgX3Y8e2ibkrqMdsjGLAuV1vrc7PidEe4k7ZyTgjYJ6cA0X2ttiUuqQhk8rCW
        bA1OaFyLdHolW
X-Received: by 2002:adf:d1e8:0:b0:21b:b7dc:68e with SMTP id g8-20020adfd1e8000000b0021bb7dc068emr25386632wrd.683.1656932664000;
        Mon, 04 Jul 2022 04:04:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uC8pVOnL2C020eJ5sZKL3StC87b8SldI7PLS1G/8+wBNOr79faqgITskCpRG1BFWbIhw1SiQ==
X-Received: by 2002:adf:d1e8:0:b0:21b:b7dc:68e with SMTP id g8-20020adfd1e8000000b0021bb7dc068emr25386608wrd.683.1656932663759;
        Mon, 04 Jul 2022 04:04:23 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id f20-20020a05600c155400b0039c41686421sm17712919wmg.17.2022.07.04.04.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 04:04:23 -0700 (PDT)
Message-ID: <fddf5ca6-77dc-88f9-c191-7de09717063c@redhat.com>
Date:   Mon, 4 Jul 2022 13:04:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v6 3/5] fbdev: Disable sysfb device registration when
 removing conflicting FBs
Content-Language: en-US
To:     Xi Ruoyao <xry111@linuxfromscratch.org>,
        Zack Rusin <zackr@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lersek@redhat.com" <lersek@redhat.com>
References: <20220607182338.344270-1-javierm@redhat.com>
 <20220607182338.344270-4-javierm@redhat.com>
 <de83ae8cb6de7ee7c88aa2121513e91bb0a74608.camel@vmware.com>
 <38473dcd-0666-67b9-28bd-afa2d0ce434a@redhat.com>
 <603e3613b9b8ff7815b63f294510d417b5b12937.camel@vmware.com>
 <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
 <97565fb5-cf7f-5991-6fb3-db96fe239ee8@redhat.com>
 <711c88299ef41afd8556132b7c1dcb75ee7e6117.camel@vmware.com>
 <aa144e20-a555-5c30-4796-09713c12ab0e@redhat.com>
 <64c753c98488a64b470009e45769ceab29fd8130.camel@linuxfromscratch.org>
 <61f2e4e2af40cb9d853504d0a6fe01829ff8ca60.camel@linuxfromscratch.org>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <61f2e4e2af40cb9d853504d0a6fe01829ff8ca60.camel@linuxfromscratch.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Xi,

On 7/4/22 12:29, Xi Ruoyao wrote:
> On Mon, 2022-07-04 at 17:36 +0800, Xi Ruoyao wrote:
> 
>>> Yes, please do. Either with CONFIG_SYSFB_SIMPLEFB disabled and CONFIG_FB_EFI
>>> enabled (so that "efi-framebuffer" is registered and efifb probed) or with
>>> CONFIG_SYSFB_SIMPLEFB but CONFIG_FB_SIMPLE enabled (so "simple-framebuffer
>>> is used too but with simplefb instead of simpledrm).
>>>  
>>> I'm not able to reproduce, it would be useful to have another data point.
>>
>> Also happening for me with CONFIG_SYSFB_SIMPLEFB, on a Intel Core i7-
>> 1065G7 (with iGPU).
>>
>> Reverting this commit on top of 5.19-rc5 "fixes" the issue.
> 
> With CONFIG_SYSFB_SIMPLEFB and CONFIG_FB_SIMPLE enabled, there is no
> issue.
> 
> I guess it's something going wrong on a "drm -> drm" pass over.  For now
> I'll continue to use simpledrm with this commit reverted.
> 

Yes, we need to also cherry-pick b84efa28a48 ("drm/aperture: Run fbdev
removal before internal helpers") now that the sysfb_disable() patches
are in v5.19-rc5.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

