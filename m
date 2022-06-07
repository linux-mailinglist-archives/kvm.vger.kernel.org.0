Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7205403B7
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 18:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbiFGQ2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 12:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344973AbiFGQ2I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 12:28:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDA57703E6
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 09:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654619284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrAl4X9lQHa6ImUpXg4wJtJNI7HGCy4MpInWNhicFSE=;
        b=a9oy0OoefZuM2rZ7nkdouLMRxUbokczaPFsxU7YO3N5RHDL6OsBPlPds+siIlEs0sZ2Omf
        I50wJPlT2+qmqW58sNlgGHiGtYL74PxGeiYnMqCnSb6aQlL/ZiYSAln3M+oAgL6vVQJjOe
        4aKjk+5Z+dhXaC0K7DeelDekVZrY/zk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-ceqmJsaSNgmsNEsDOKKVkw-1; Tue, 07 Jun 2022 12:28:03 -0400
X-MC-Unique: ceqmJsaSNgmsNEsDOKKVkw-1
Received: by mail-wm1-f70.google.com with SMTP id e19-20020a05600c4e5300b0039c4b6acd83so4466615wmq.2
        for <kvm@vger.kernel.org>; Tue, 07 Jun 2022 09:28:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QrAl4X9lQHa6ImUpXg4wJtJNI7HGCy4MpInWNhicFSE=;
        b=w7k28XANK725OuINKLuyOuNZR7QRDlLh9oyjntEzGIG/5pkgmUXAwDYvRR8t7HOy0Y
         Y5VlkaFz87AKRgNv4F+QcxZ99F3lcOYZKxNpYFHtNlemGJuGZYX7NPO1NzLc3ACKM9c6
         XV2nlD9XWruRxfZyTaqUHD8uJWPLtanA30Lu2OaqupTYoxA1UwE7zYF5zSh2rEu4QoSH
         uRJwkrJT4N22tgL/lZOxoWYMnoU+LpWwDzXPWahXg3sXREyAgshpBw5KZw/UCQufAYs9
         NO5OoDRdYjsJbnHnQFRcTCrENmd98qK1UfbFU7+H4d8CZqL5Z8SMtPPhA6kRFRI1JJq9
         9PYA==
X-Gm-Message-State: AOAM533GJ6cUkh/GrbXCqz1qUT4POqpZL/2lFjaOB3QiF82IA6m8A4sc
        fuBEjVugg2JLWvBB/Qrw2n5Rz4L350HbtabKUQyof2QwCcSC1nA600Qcg9Yq3jAaV1AQBQ3gL+q
        XaD72iwzV2Mjp
X-Received: by 2002:adf:fe90:0:b0:210:7e22:186e with SMTP id l16-20020adffe90000000b002107e22186emr29301437wrr.321.1654619282675;
        Tue, 07 Jun 2022 09:28:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRDGHUN1V8ilpafmjMJrCpHoJfcLfR+x/HPQ5S4rcMfI1wOnucWWWA4grpheVXro8sbOyqfA==
X-Received: by 2002:adf:fe90:0:b0:210:7e22:186e with SMTP id l16-20020adffe90000000b002107e22186emr29301405wrr.321.1654619282385;
        Tue, 07 Jun 2022 09:28:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id c186-20020a1c35c3000000b0039bc95cf4b2sm20949223wma.11.2022.06.07.09.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 09:28:01 -0700 (PDT)
Message-ID: <1999b2b7-13a8-8d91-89fb-6b624bc7dd15@redhat.com>
Date:   Tue, 7 Jun 2022 18:27:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL 00/15] KVM: s390: pv dump and selftest changes
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/1/22 17:36, Christian Borntraeger wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.19-2

Pulled now, thanks.

Paolo

