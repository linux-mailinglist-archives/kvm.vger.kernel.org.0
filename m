Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF48A7A5E0D
	for <lists+kvm@lfdr.de>; Tue, 19 Sep 2023 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbjISJfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Sep 2023 05:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjISJfv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Sep 2023 05:35:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02883CE7
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 02:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695116098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KPR96Ino/qT336oazWqMngmq6HsgDYc3ttnsN9zP/FQ=;
        b=Jg7wwilupK1Jc1dLOREYhu67BppZ+eYtNJnF6pjmTSxGRJop0taXgCzjtZ2AKjPI4ZTkg5
        l7ijPh50vorvFXv+iV+m5UJPKFfUWt7wEPvrbPILvPgAVsmlXVFQ9Ojqb3tw2EKv8Ndi7o
        UOfJpW2Hox4FRkXVPqSE28/pV3afvMQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-Rik-VeNOPHS_pHgVQ5TITQ-1; Tue, 19 Sep 2023 05:34:56 -0400
X-MC-Unique: Rik-VeNOPHS_pHgVQ5TITQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fd0fa4d08cso40248745e9.1
        for <kvm@vger.kernel.org>; Tue, 19 Sep 2023 02:34:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695116095; x=1695720895;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KPR96Ino/qT336oazWqMngmq6HsgDYc3ttnsN9zP/FQ=;
        b=m2Jqvr3qqpQ0ltwfMQiIUUQXUTvpw6uAxZLtIPsX2qFFTZBHbpQAddbTlH7GIhuIj7
         y/QBDGLQJeeel7ThKFnJCiZCuSQPoJ0LBC4NTnBb6D+3K1lzvs/MfLlQ+l0apCBDl4SX
         AyTK3oRZvfQqCUYwx+8fmi8qL+aCZt6DrPDIqVwdS1PIv9R2F15AfUYVN8RUlPG9eOf7
         +M/m6yq/EhaHNLq5OqrI8scoKJGquty1p1WBAfVBR6F1xTcxlHJZ4D9HHmfwK/vulTFa
         6pBw+dNrciUTEGLZDJi9cMb+L1YVctZa0WvndTYY6BRdYv47GhRefe/C0Z8fpifubvAu
         ECmw==
X-Gm-Message-State: AOJu0Ywh2Mh+y95Suv+2/ryxbn9yeO4cSeUuaHjGslWhRbC2SVeW6CAu
        0B4zyLlmGKhx1kSciPj/TgAGC21I0LhAtnRJpWr5Du6yH2CF77nM91b18SzPyJolj4XplWD25Ws
        YvpOu1KWbIwb+
X-Received: by 2002:a7b:c4cb:0:b0:401:b53e:6c56 with SMTP id g11-20020a7bc4cb000000b00401b53e6c56mr11412919wmk.3.1695116095748;
        Tue, 19 Sep 2023 02:34:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHh1b95ySDTxVNVqccpxTqPuEHUzr58Fl6Hb7D0bbeRcDlZIBfNAdbbcqTsXYpZs//RQv6EMQ==
X-Received: by 2002:a7b:c4cb:0:b0:401:b53e:6c56 with SMTP id g11-20020a7bc4cb000000b00401b53e6c56mr11412888wmk.3.1695116095291;
        Tue, 19 Sep 2023 02:34:55 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:1300:c409:8b33:c793:108e? (p200300cbc7021300c4098b33c793108e.dip0.t-ipconnect.de. [2003:cb:c702:1300:c409:8b33:c793:108e])
        by smtp.gmail.com with ESMTPSA id c22-20020a7bc856000000b00402f7e473b7sm14562093wml.15.2023.09.19.02.34.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 02:34:54 -0700 (PDT)
Message-ID: <b6b088fa-621b-1017-9d71-5757f81bf1ec@redhat.com>
Date:   Tue, 19 Sep 2023 11:34:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/16] virtio-mem: Expose device memory through
 multiple memslots
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230908142136.403541-1-david@redhat.com>
 <87e38689-c99b-0c92-3567-589cd9a2bc4c@redhat.com>
 <90303827-7879-7b9e-836d-5026b2be73dd@redhat.com>
Organization: Red Hat
In-Reply-To: <90303827-7879-7b9e-836d-5026b2be73dd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.09.23 10:20, David Hildenbrand wrote:
> On 11.09.23 09:45, David Hildenbrand wrote:
>> @MST, any comment on the vhost bits (mostly uncontroversial and only in
>> the memslot domain)?
>>
>> I'm planning on queuing this myself (but will wait a bit more), unless
>> you want to take it.
> 
> I'm queuing this to
> 
> https://github.com/davidhildenbrand/qemu.git mem-next
> 
> and plan on sending a PULL request on Friday.
> 
> So if anybody has objections, please let me know ASAP :)
> 

.... and I dropped it again after realizing that migration needs care 
(activate memslots on migrationd estination). I'll look into that and 
resend once that is fixed.

-- 
Cheers,

David / dhildenb

