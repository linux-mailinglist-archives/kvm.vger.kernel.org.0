Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0751D592C67
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242298AbiHOKJT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbiHOKJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:09:18 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D06D165A4;
        Mon, 15 Aug 2022 03:09:17 -0700 (PDT)
Received: from [IPV6:2a00:5f00:102:0:10b3:10ff:fe5d:4ec1] (unknown [IPv6:2a00:5f00:102:0:10b3:10ff:fe5d:4ec1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dmitry.osipenko)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 76D4166016A1;
        Mon, 15 Aug 2022 11:09:14 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660558155;
        bh=IxA0RyRCASMAbomjQ2FWjdpXxwbEqxEzDpKA7fGLa7Q=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=go6c+u43kUxsC/J1y+p7RUVs759KcyhNIhYyXhunR6hhypP/9riSdcsuKp9xYkp9z
         zhxWZeGVtPTWSmnnhLpvXwmlqZUubpnEZ5Rn75kcnFUaMdCAuWKmi4tYq9T3Jwy6Y3
         2OZZQkT9PP/tBSmpvDs5SFHnzaPpglhOQkYAV3nbdIL+5J5nE6pKG9NVZO6vUuL7Rh
         7zCsGxGex5LS/fC62BDhwS6clWn0oioBq7sPlILr5ze//9trIq4GRbpsdv/U9Wgykt
         qR0xDhFOJK2vibBgqzspHgpag3ADM+XPkgfYvDrP7s4iXjtWFZQYCG5Iq/UML8QGTY
         GFlSyHuGlBNNQ==
Message-ID: <134bce02-58d6-8553-bb73-42dfda18a595@collabora.com>
Date:   Mon, 15 Aug 2022 13:09:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v1] drm/ttm: Refcount allocated tail pages
Content-Language: en-US
To:     =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, Huang Rui <ray.huang@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Trigger Huang <Trigger.Huang@gmail.com>,
        Gert Wollny <gert.wollny@collabora.com>,
        Antonio Caggiano <antonio.caggiano@collabora.com>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dmitry Osipenko <digetx@gmail.com>, kvm@vger.kernel.org,
        kernel@collabora.com, virtualization@lists.linux-foundation.org
References: <20220815095423.11131-1-dmitry.osipenko@collabora.com>
 <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com>
From:   Dmitry Osipenko <dmitry.osipenko@collabora.com>
In-Reply-To: <8230a356-be38-f228-4a8e-95124e8e8db6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/15/22 13:05, Christian König wrote:
> Am 15.08.22 um 11:54 schrieb Dmitry Osipenko:
>> Higher order pages allocated using alloc_pages() aren't refcounted and
>> they
>> need to be refcounted, otherwise it's impossible to map them by KVM. This
>> patch sets the refcount of the tail pages and fixes the KVM memory
>> mapping
>> faults.
>>
>> Without this change guest virgl driver can't map host buffers into guest
>> and can't provide OpenGL 4.5 profile support to the guest. The host
>> mappings are also needed for enabling the Venus driver using host GPU
>> drivers that are utilizing TTM.
>>
>> Based on a patch proposed by Trigger Huang.
> 
> Well I can't count how often I have repeated this: This is an absolutely
> clear NAK!
> 
> TTM pages are not reference counted in the first place and because of
> this giving them to virgl is illegal.

A? The first page is refcounted when allocated, the tail pages are not.

> Please immediately stop this completely broken approach. We have
> discussed this multiple times now.

Could you please give me a link to these discussions?

-- 
Best regards,
Dmitry
