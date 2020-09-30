Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536EC27F158
	for <lists+kvm@lfdr.de>; Wed, 30 Sep 2020 20:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgI3ScU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 14:32:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58660 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbgI3ScT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 14:32:19 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601490736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSEYn0mTBiBY7UJW5WQEORV+qSC4UpVXy7sOotwqICM=;
        b=eJIxbED9k0plXUaLUR0aX5snLT0nioY/EnqUd+WjrlPDR+LgUvs9DexsfIFgi+YDpN3NFY
        EszPrzx1xlEJcU43fXXOWxwy1RwuAnegoof89/3FfVrc3LL8nXF1TYXrufzh/3J1pUij0o
        gQWZgfrJ7XTJoJCip1XBZiouD0gleC5aCWRIEE8IGQ42wKzk300pNExkI9EavQT1b3Jt/Q
        pdxEJXOFDXzMO9gTV5o/Z5s/zVFGTpwtaP3vSCo4JFfGqb11kl9VsN/Y5vjOPtsEpQZZQ3
        NuRGr7AlO5gc/qDlB9GunGLn19ubV+tO4epWQzTvuXt+itOwIMzWHyToU/gekA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601490736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WSEYn0mTBiBY7UJW5WQEORV+qSC4UpVXy7sOotwqICM=;
        b=QweKkWrlkg7qwTnuHdfynFskeFSOOP6+5dDTmfuAMT/TYKu5kIblTsFprhAekFC7NNbJ2K
        ND6e2WNkjegHReBA==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/18] iommu/vt-d: Add DEV-MSI support
In-Reply-To: <160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com>
References: <160021207013.67751.8220471499908137671.stgit@djiang5-desk3.ch.intel.com> <160021246905.67751.1674517279122764758.stgit@djiang5-desk3.ch.intel.com>
Date:   Wed, 30 Sep 2020 20:32:15 +0200
Message-ID: <87zh57glow.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 15 2020 at 16:27, Dave Jiang wrote:
> @@ -1303,9 +1303,10 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
>  	case X86_IRQ_ALLOC_TYPE_HPET:
>  	case X86_IRQ_ALLOC_TYPE_PCI_MSI:
>  	case X86_IRQ_ALLOC_TYPE_PCI_MSIX:
> +	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
>  		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
>  			set_hpet_sid(irte, info->devid);
> -		else
> +		else if (info->type != X86_IRQ_ALLOC_TYPE_DEV_MSI)
>  			set_msi_sid(irte,
>  			msi_desc_to_pci_dev(info->desc));

Gah. this starts to become unreadable.

diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 8f4ce72570ce..0c1ea8ceec31 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1271,6 +1271,16 @@ static struct irq_chip intel_ir_chip = {
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,
 };
 
+static void irte_prepare_msg(struct msi_msg *msg, int index, int subhandle)
+{
+	msg->address_hi = MSI_ADDR_BASE_HI;
+	msg->data = sub_handle;
+	msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
+			  MSI_ADDR_IR_SHV |
+			  MSI_ADDR_IR_INDEX1(index) |
+			  MSI_ADDR_IR_INDEX2(index);
+}
+
 static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 					     struct irq_cfg *irq_cfg,
 					     struct irq_alloc_info *info,
@@ -1312,19 +1322,18 @@ static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
 		break;
 
 	case X86_IRQ_ALLOC_TYPE_HPET:
+		set_hpet_sid(irte, info->hpet_id);
+		irte_prepare_msg(msg, index, sub_handle);
+		break;
+
 	case X86_IRQ_ALLOC_TYPE_MSI:
 	case X86_IRQ_ALLOC_TYPE_MSIX:
-		if (info->type == X86_IRQ_ALLOC_TYPE_HPET)
-			set_hpet_sid(irte, info->hpet_id);
-		else
-			set_msi_sid(irte, info->msi_dev);
-
-		msg->address_hi = MSI_ADDR_BASE_HI;
-		msg->data = sub_handle;
-		msg->address_lo = MSI_ADDR_BASE_LO | MSI_ADDR_IR_EXT_INT |
-				  MSI_ADDR_IR_SHV |
-				  MSI_ADDR_IR_INDEX1(index) |
-				  MSI_ADDR_IR_INDEX2(index);
+		set_msi_sid(irte, info->msi_dev);
+		irte_prepare_msg(msg, index, sub_handle);
+		break;
+
+	case X86_IRQ_ALLOC_TYPE_DEV_MSI:
+		irte_prepare_msg(msg, index, sub_handle);
 		break;
 
 	default:

Hmm?

Thanks,

        tglx
