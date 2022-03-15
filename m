Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2744D99A1
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 11:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347697AbiCOKwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 06:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347643AbiCOKvz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 06:51:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EEDDC3BA4A;
        Tue, 15 Mar 2022 03:49:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 945BE1474;
        Tue, 15 Mar 2022 03:49:11 -0700 (PDT)
Received: from [10.57.42.204] (unknown [10.57.42.204])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B3C03F66F;
        Tue, 15 Mar 2022 03:49:06 -0700 (PDT)
Message-ID: <a9637631-c23b-4158-d2cb-597a36b09a6b@arm.com>
Date:   Tue, 15 Mar 2022 10:49:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v4 14/32] iommu: introduce iommu_domain_alloc_type and the
 KVM type
Content-Language: en-GB
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        linux-kernel@vger.kernel.org, vneethv@linux.ibm.com,
        agordeev@linux.ibm.com, imbrenda@linux.ibm.com, will@kernel.org,
        frankja@linux.ibm.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        pasic@linux.ibm.com, jgg@nvidia.com, gerald.schaefer@linux.ibm.com,
        borntraeger@linux.ibm.com, farman@linux.ibm.com, gor@linux.ibm.com,
        schnelle@linux.ibm.com, hca@linux.ibm.com,
        alex.williamson@redhat.com, freude@linux.ibm.com,
        pmorel@linux.ibm.com, cohuck@redhat.com, oberpar@linux.ibm.com,
        iommu@lists.linux-foundation.org, svens@linux.ibm.com,
        pbonzini@redhat.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-15-mjrosato@linux.ibm.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20220314194451.58266-15-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-14 19:44, Matthew Rosato wrote:
> s390x will introduce an additional domain type that is used for
> managing IOMMU owned by KVM.  Define the type here and add an
> interface for allocating a specified type vs the default type.

I'm also not a huge fan of adding a new domain_alloc interface like 
this, however if it is justifiable, then please make it take struct 
device rather than struct bus_type as an argument.

It also sounds like there may be a degree of conceptual overlap here 
with what Jean-Philippe is working on for sharing pagetables between KVM 
and SMMU for Android pKVM, so it's probably worth some thought over 
whether there's any scope for common interfaces in terms of actual 
implementation.

Thanks,
Robin.

> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   drivers/iommu/iommu.c |  7 +++++++
>   include/linux/iommu.h | 12 ++++++++++++
>   2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index f2c45b85b9fc..8bb57e0e3945 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1976,6 +1976,13 @@ void iommu_domain_free(struct iommu_domain *domain)
>   }
>   EXPORT_SYMBOL_GPL(iommu_domain_free);
>   
> +struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
> +					     unsigned int t)
> +{
> +	return __iommu_domain_alloc(bus, t);
> +}
> +EXPORT_SYMBOL_GPL(iommu_domain_alloc_type);
> +
>   static int __iommu_attach_device(struct iommu_domain *domain,
>   				 struct device *dev)
>   {
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 9208eca4b0d1..b427bbb9f387 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -63,6 +63,7 @@ struct iommu_domain_geometry {
>   					      implementation              */
>   #define __IOMMU_DOMAIN_PT	(1U << 2)  /* Domain is identity mapped   */
>   #define __IOMMU_DOMAIN_DMA_FQ	(1U << 3)  /* DMA-API uses flush queue    */
> +#define __IOMMU_DOMAIN_KVM	(1U << 4)  /* Domain is controlled by KVM */
>   
>   /*
>    * This are the possible domain-types
> @@ -77,6 +78,7 @@ struct iommu_domain_geometry {
>    *				  certain optimizations for these domains
>    *	IOMMU_DOMAIN_DMA_FQ	- As above, but definitely using batched TLB
>    *				  invalidation.
> + *	IOMMU_DOMAIN_KVM	- DMA mappings managed by KVM, used for VMs
>    */
>   #define IOMMU_DOMAIN_BLOCKED	(0U)
>   #define IOMMU_DOMAIN_IDENTITY	(__IOMMU_DOMAIN_PT)
> @@ -86,6 +88,8 @@ struct iommu_domain_geometry {
>   #define IOMMU_DOMAIN_DMA_FQ	(__IOMMU_DOMAIN_PAGING |	\
>   				 __IOMMU_DOMAIN_DMA_API |	\
>   				 __IOMMU_DOMAIN_DMA_FQ)
> +#define IOMMU_DOMAIN_KVM	(__IOMMU_DOMAIN_PAGING |	\
> +				 __IOMMU_DOMAIN_KVM)
>   
>   struct iommu_domain {
>   	unsigned type;
> @@ -421,6 +425,8 @@ extern bool iommu_capable(struct bus_type *bus, enum iommu_cap cap);
>   extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
>   extern struct iommu_group *iommu_group_get_by_id(int id);
>   extern void iommu_domain_free(struct iommu_domain *domain);
> +extern struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
> +						    unsigned int t);
>   extern int iommu_attach_device(struct iommu_domain *domain,
>   			       struct device *dev);
>   extern void iommu_detach_device(struct iommu_domain *domain,
> @@ -708,6 +714,12 @@ static inline void iommu_domain_free(struct iommu_domain *domain)
>   {
>   }
>   
> +static inline struct iommu_domain *iommu_domain_alloc_type(struct bus_type *bus,
> +							   unsigned int t)
> +{
> +	return NULL;
> +}
> +
>   static inline int iommu_attach_device(struct iommu_domain *domain,
>   				      struct device *dev)
>   {
