Return-Path: <kvm+bounces-4053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8BAB80CF1E
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 16:12:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7446A281CCD
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 15:12:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 591C94A9B9;
	Mon, 11 Dec 2023 15:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dJn8Krm8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D5FF1
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:12:37 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-77f335002cfso284487485a.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 07:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1702307556; x=1702912356; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9BcXaEe04wsiYi+jVUtHZ96GrfMgRR6SNn2Jekjosbw=;
        b=dJn8Krm8CVupD7xQ0LE+7gi/QoFJBcPjbWjosJ5jt11OxQPGaP8cvsjYs2JxPod+ZA
         XnkqaE1bt/O4BjYs71BYeLVPox084VUmG3A7sdiMek2yaEo1IFQ2D7gfSlM/dtCw80Tc
         S38w9G35CCfjbc9XIZP9JmvQRSrJduJnYY5gVajbtFyFH5BUQEKuYo4HUKS5i+v641hU
         UOJtnBw1GV+WlrXR6Y8LpHUILNGj1bp5ESRUcYumyWQdb0Ia6FO31VjYt7mlmFOfYRXH
         Yn0vOvfuFxJ2ap3labjDHbGaNJY+WqNe6SjaO/q9Czn93WBDqA+5Q6Z5VDL06cLZ4bil
         tUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702307556; x=1702912356;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BcXaEe04wsiYi+jVUtHZ96GrfMgRR6SNn2Jekjosbw=;
        b=FwnHEols+0d3kAoUrBD11BCXsXrseOGSL9Z/RlpSFhNIRTqamycdxd3rrjybx7bBHn
         l12XqRF+WiyeljBmRde617imqVR1LcK1QFlHtFjL2SZ5cldKLNy8LLTPi8339hiynWM5
         AhESqORcgIpIx4mE3y3FhINaw4duZU+35EZw2YeCcHQCwT9bjrvjXV0TbccasS6KRFsV
         0j6qdmvrv/dSodkHg0pNwFEJbklqXTizvYedPf7oAI3lq8FJL2eBKEutSb8J6DeGNjoE
         5xkgLA5i/CCqAZIv6iRaLvMqOaTJx4zhsfF8kWrAfGszNwLVDktSsgLvhyhng5YLNyHP
         k0fA==
X-Gm-Message-State: AOJu0YxMlFgrf2cE6CjAE7JlVELzDbjYHcPORMix2sLW4DuAAofKXRvj
	KOtdBIVkXWL+krEYqSY23CtnZw==
X-Google-Smtp-Source: AGHT+IETaBdKmCMU8wf7A05/MNS1AJow0FY9ZM2OzwBlmMfqdMQer9Be2sf6osE+CPp3FrHn69KTiA==
X-Received: by 2002:a05:620a:2201:b0:77a:55b2:5dae with SMTP id m1-20020a05620a220100b0077a55b25daemr4753742qkh.53.1702307556526;
        Mon, 11 Dec 2023 07:12:36 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-134-23-187.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.134.23.187])
        by smtp.gmail.com with ESMTPSA id 26-20020a05620a04da00b0077d7557653bsm2986936qks.64.2023.12.11.07.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 07:12:35 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rChxT-00CcMk-Ec;
	Mon, 11 Dec 2023 11:12:35 -0400
Date: Mon, 11 Dec 2023 11:12:35 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Message-ID: <20231211151235.GA1489931@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207064308.313316-13-baolu.lu@linux.intel.com>

On Thu, Dec 07, 2023 at 02:43:08PM +0800, Lu Baolu wrote:
> +/*
> + * Return the fault parameter of a device if it exists. Otherwise, return NULL.
> + * On a successful return, the caller takes a reference of this parameter and
> + * should put it after use by calling iopf_put_dev_fault_param().
> + */
> +static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
> +{
> +	struct dev_iommu *param = dev->iommu;
> +	struct iommu_fault_param *fault_param;
> +
> +	if (!param)
> +		return NULL;

Is it actually possible to call this function on a device that does
not have an iommu driver probed? I'd be surprised by that, maybe this
should be WARN_ONE

> +
> +	rcu_read_lock();
> +	fault_param = param->fault_param;

The RCU stuff is not right, like this:

diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 2ace32c6d13bf3..0258f79c8ddf98 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -40,7 +40,7 @@ static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
 		return NULL;
 
 	rcu_read_lock();
-	fault_param = param->fault_param;
+	fault_param = rcu_dereference(param->fault_param);
 	if (fault_param && !refcount_inc_not_zero(&fault_param->users))
 		fault_param = NULL;
 	rcu_read_unlock();
@@ -51,17 +51,8 @@ static struct iommu_fault_param *iopf_get_dev_fault_param(struct device *dev)
 /* Caller must hold a reference of the fault parameter. */
 static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
 {
-	struct dev_iommu *param = fault_param->dev->iommu;
-
-	rcu_read_lock();
-	if (!refcount_dec_and_test(&fault_param->users)) {
-		rcu_read_unlock();
-		return;
-	}
-	rcu_read_unlock();
-
-	param->fault_param = NULL;
-	kfree_rcu(fault_param, rcu);
+	if (refcount_dec_and_test(&fault_param->users))
+		kfree_rcu(fault_param, rcu);
 }
 
 /**
@@ -174,7 +165,7 @@ static int iommu_handle_iopf(struct iommu_fault *fault,
 	}
 
 	mutex_unlock(&iopf_param->lock);
-	ret = domain->iopf_handler(group);
+	ret = domain->iopf_handler(iopf_param, group);
 	mutex_lock(&iopf_param->lock);
 	if (ret)
 		iopf_free_group(group);
@@ -398,7 +389,8 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
-	if (param->fault_param) {
+	if (rcu_dereference_check(param->fault_param,
+				  lockdep_is_held(&param->lock))) {
 		ret = -EBUSY;
 		goto done_unlock;
 	}
@@ -418,7 +410,7 @@ int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
 	list_add(&fault_param->queue_list, &queue->devices);
 	fault_param->queue = queue;
 
-	param->fault_param = fault_param;
+	rcu_assign_pointer(param->fault_param, fault_param);
 
 done_unlock:
 	mutex_unlock(&param->lock);
@@ -442,10 +434,12 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	int ret = 0;
 	struct iopf_fault *iopf, *next;
 	struct dev_iommu *param = dev->iommu;
-	struct iommu_fault_param *fault_param = param->fault_param;
+	struct iommu_fault_param *fault_param;
 
 	mutex_lock(&queue->lock);
 	mutex_lock(&param->lock);
+	fault_param = rcu_dereference_check(param->fault_param,
+					    lockdep_is_held(&param->lock));
 	if (!fault_param) {
 		ret = -ENODEV;
 		goto unlock;
@@ -467,7 +461,10 @@ int iopf_queue_remove_device(struct iopf_queue *queue, struct device *dev)
 	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
 		kfree(iopf);
 
-	iopf_put_dev_fault_param(fault_param);
+	/* dec the ref owned by iopf_queue_add_device() */
+	rcu_assign_pointer(param->fault_param, NULL);
+	if (refcount_dec_and_test(&fault_param->users))
+		kfree_rcu(fault_param, rcu);
 unlock:
 	mutex_unlock(&param->lock);
 	mutex_unlock(&queue->lock);
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 325d1810e133a1..63c1a233a7e91f 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -232,10 +232,9 @@ static void iommu_sva_handle_iopf(struct work_struct *work)
 	iopf_free_group(group);
 }
 
-static int iommu_sva_iopf_handler(struct iopf_group *group)
+static int iommu_sva_iopf_handler(struct iommu_fault_param *fault_param,
+				  struct iopf_group *group)
 {
-	struct iommu_fault_param *fault_param = group->dev->iommu->fault_param;
-
 	INIT_WORK(&group->work, iommu_sva_handle_iopf);
 	if (!queue_work(fault_param->queue->wq, &group->work))
 		return -EBUSY;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 8020bb44a64ab1..e16fa9811d5023 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -41,6 +41,7 @@ struct iommu_dirty_ops;
 struct notifier_block;
 struct iommu_sva;
 struct iommu_dma_cookie;
+struct iommu_fault_param;
 
 #define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
 #define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
@@ -210,7 +211,8 @@ struct iommu_domain {
 	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
 	struct iommu_domain_geometry geometry;
 	struct iommu_dma_cookie *iova_cookie;
-	int (*iopf_handler)(struct iopf_group *group);
+	int (*iopf_handler)(struct iommu_fault_param *fault_param,
+			    struct iopf_group *group);
 	void *fault_data;
 	union {
 		struct {
@@ -637,7 +639,7 @@ struct iommu_fault_param {
  */
 struct dev_iommu {
 	struct mutex lock;
-	struct iommu_fault_param	*fault_param;
+	struct iommu_fault_param __rcu	*fault_param;
 	struct iommu_fwspec		*fwspec;
 	struct iommu_device		*iommu_dev;
 	void				*priv;

