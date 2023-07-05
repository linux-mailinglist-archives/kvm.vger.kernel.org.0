Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1807481A8
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 12:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjGEKDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 06:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjGEKDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 06:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB631719
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 03:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688551384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcn+7FSWO3Q6p4kQd9xNkcM9RaSbtdZr+9l8xzd+0w4=;
        b=TLjtTIXOBeH5ZcSXaujqyW7YtlnjBsq6IBp8e8FT+HfvVs5v4RZalM7USX8FmuLvl+SPUc
        HG9NrGryrxwC/VRdjMi3JxvIdxRZjYf83UYGKDTFiYTLk27wbiPu+gFvNjKAlhbBP/v97D
        iAvRa3MkN4pG6Xhix+R7FRybWw+sGBo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-657-MX2UIYW0MMmluiGkkXSdcg-1; Wed, 05 Jul 2023 06:03:02 -0400
X-MC-Unique: MX2UIYW0MMmluiGkkXSdcg-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6372702c566so13889036d6.2
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 03:03:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688551382; x=1691143382;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wcn+7FSWO3Q6p4kQd9xNkcM9RaSbtdZr+9l8xzd+0w4=;
        b=KrotFotlrYB1wV48Dir0lHLihTgv4TlLjwrRk2WGXrV0+ve/bX2rz52PdL5p0GA5Pe
         BtbPVBkK/2xccTMa543f+KxBTYcF8BEP/WC9W5Kk4r5YG98IOlsDNcYTE3YPNnAGLAjq
         Hqk43KOnHu5FwcxPhjazkH/hIdZKQPgytfWCngZix3dRf2slE+FvAE6M5wZhG9S93W4U
         y8cwMLgmCT5b5P59djqz5tgmlMQW/ywVyxjRxpa+PIFAbNbo6xa6MoVdKkqitkMJTEAg
         t/nOoqfhVjcvqI9umXqeOlkX/SSvUOqc8evtUPlnTfwRU/p8TdlRA92a68c1z9oNDYML
         xf4w==
X-Gm-Message-State: ABy/qLZl+z/V78iysjV4lsOpz+ILjLKhkSdJYNR89bk+l0QvBt8Ei9Zn
        wTyM3Q8Re6H8dPpZrLG91lLTrM9ao/R7nT9JNtSiSjzKnUOO6G7OtUJJa8OXvBWQi8uixhGDXWp
        iK8E+27rRgwEP
X-Received: by 2002:a05:6214:528e:b0:636:fda0:a23 with SMTP id kj14-20020a056214528e00b00636fda00a23mr6501930qvb.27.1688551382511;
        Wed, 05 Jul 2023 03:03:02 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHRo34E4ELVzciCfO6o6DgM67R0waGD/cUsmQW3QZt8hvDcwxLibx/OTtVskYC+A5fGCWt9Vg==
X-Received: by 2002:a05:6214:528e:b0:636:fda0:a23 with SMTP id kj14-20020a056214528e00b00636fda00a23mr6501909qvb.27.1688551382291;
        Wed, 05 Jul 2023 03:03:02 -0700 (PDT)
Received: from [10.33.192.205] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id o15-20020a0ceccf000000b0063642bcc5e4sm6541019qvq.9.2023.07.05.03.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 03:03:01 -0700 (PDT)
Message-ID: <e5387fc9-f8b0-3905-8b48-88409c251710@redhat.com>
Date:   Wed, 5 Jul 2023 12:02:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v21 00/20] s390x: CPU Topology
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        nsg@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
References: <20230630091752.67190-1-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20230630091752.67190-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/06/2023 11.17, Pierre Morel wrote:
...
> Testing
> =======
> 
> To use the QEMU patches, you will need Linux V6-rc1 or newer,
> or use the following Linux mainline patches:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac..
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> This series provide 12 avocado tests using Fedora-35 kernel and initrd
> image.

  Hi Pierre,

the new avocado tests currently fail if you run them on a x86 host. Could 
you please add a check that they are properly skipped instead if the 
environment does not match? I guess a

  self.require_accelerator('kvm')

should do the job...

  Thomas

