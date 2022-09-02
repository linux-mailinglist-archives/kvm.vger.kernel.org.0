Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57EE65AA8CA
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 09:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbiIBHdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 03:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234101AbiIBHdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 03:33:45 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C14B95B2;
        Fri,  2 Sep 2022 00:33:43 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MJqQl58dbz4x3w;
        Fri,  2 Sep 2022 17:33:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1662104018;
        bh=hJz4SNP/i8v13NyeDRi0y+oMlEr1XHuTWGnDprX6daM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=YyrF+RKm94p4H69k34qmNhTyfugOGBhOU1aA+9znafWxn/h4F9PHIWnES/jeymJrG
         Otp/P6Sjl6ZBkzMpdoWscYZJV/urdVVi/ZtVji9B1j4DVjZEcdEMaAsgv8GPnPKX/J
         0WJmvCVhTVgSRMngStPYDiUBoEf/tXQbwKJNBRqBiik7ii2FyafHLgqB1zSpTLdhzD
         iiLxB6w6xVwGBix9fSd4eEBalk8whscbiUr7mRZh1RtCYd/FvlE1U9ULY4pf2q6fKy
         qeqEOZJjT1enTLdk1hl2sl+p0hkG2ZKL7x061Fzi1at9SKk2H7jESsTY0clYyPHt3U
         z8ptz8ECcdmxA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Deming Wang <wangdeming@inspur.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH kernel 0/3] powerpc/iommu: Add iommu_ops to report
 capabilities and allow blocking domains
In-Reply-To: <YxFMWs3c+m/rubVk@nvidia.com>
References: <20220714081822.3717693-1-aik@ozlabs.ru>
 <YxFMWs3c+m/rubVk@nvidia.com>
Date:   Fri, 02 Sep 2022 17:33:30 +1000
Message-ID: <87tu5qtelx.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason Gunthorpe <jgg@nvidia.com> writes:
> On Thu, Jul 14, 2022 at 06:18:19PM +1000, Alexey Kardashevskiy wrote:
>> Here is another take on iommu_ops on POWER to make VFIO work
>> again on POWERPC64.
>> 
>> The tree with all prerequisites is here:
>> https://github.com/aik/linux/tree/kvm-fixes-wip
>> 
>> The previous discussion is here:
>> https://patchwork.ozlabs.org/project/linuxppc-dev/patch/20220707135552.3688927-1-aik@ozlabs.ru/
>> https://patchwork.ozlabs.org/project/kvm-ppc/patch/20220701061751.1955857-1-aik@ozlabs.ru/
>> 
>> Please comment. Thanks.
>>
>> 
>> 
>> Alexey Kardashevskiy (3):
>>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>>   powerpc/pci_64: Init pcibios subsys a bit later
>>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>>     domains
>
> It has been a little while - and I think this series is still badly
> needed by powerpc, right?

Your comments on patch 3 left me with the impression it needed a respin,
but maybe I misread that.

Alexey's reply that it needed testing also made me think it wasn't
ready to pick up.

cheers
