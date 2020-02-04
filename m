Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE11151D3D
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 16:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgBDP2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 10:28:44 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33710 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgBDP2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 10:28:43 -0500
Received: by mail-pf1-f194.google.com with SMTP id n7so9649000pfn.0
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 07:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kWIdBJk3JxZb9a1swYHLQA21jGIiXhnHzYcvlqACdeY=;
        b=Q9zih7hxV242p1Cj32z3Q0vJ0UzocJc48QZw04+yy21ZnSMtkCFWkI4EjJ6BAEs7Ke
         cgqFazl2MM+8LzwLGE1bp5iHFf/HXm0x292jX1SxkuFS9GZWPlPC0zmObc1dXHCVjYoo
         3e/tyhBJ7qGakq33VS25jUYkD9Dkrdf2/+eP86Lp6lEADSTVGGXLXgQhkdvwLmSPUgHF
         7H99BTWWAfNBnJnqRcEPBY1r8FpQoxLcN5p7IPphv4cU/T0AVOKAGmJrquEyfjcw0Cue
         nFOo31ghTAsTjCT2ZRcgQi7v2mdUDbbYlEKUPSDw8/JsDYdFmlSYgrC4HtXjj+GDtob1
         3CUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kWIdBJk3JxZb9a1swYHLQA21jGIiXhnHzYcvlqACdeY=;
        b=cX8P67XrqYOMBQ8IcydiDpqYT067JxsBthIFYr+7v7VkabxSCw1nzLLop6YOiBTA0U
         5gP4517cJ5kvAS8I+Skny/E0YedExbMBw+W3KlPymmUmQnTE23rM9dvNd11iPgnmswyx
         W7nG73zoBQ0lpzGEHzUOu3gp3Uhrfa35i/4Ty7Ui2I92cZr9MAGFOzUh5tYKRyBiAJ8J
         GpG2+2+Z7+4L2kZ8Qyo0N0+QNabzvnxaLnv3T6do/2W3cQYT88+dtDNOgusiMmvykDVL
         yktnx1fU1r2zI2XZglCfpt2Ju4L4jCCpHAmdY8WnjcX87a+sEc2ryP0C5F2cz2Breo6L
         cQow==
X-Gm-Message-State: APjAAAUUXL2Ok0DH73oozyK9CnZc9QQVGM8xTbzAyKr65KLQdm5pSiqG
        y9zmV1kwR7hXeIM9do2fXPoH3w==
X-Google-Smtp-Source: APXvYqyNNIWemMx+WkdcAbjQA2D8hHh+ZWjZYObLNn/J3pAv0AAqV7duUv3/Yyq009vO8++ezR4nEA==
X-Received: by 2002:aa7:961b:: with SMTP id q27mr31681060pfg.23.1580830122509;
        Tue, 04 Feb 2020 07:28:42 -0800 (PST)
Received: from gnomeregan.cam.corp.google.com ([2620:15c:6:14:50b7:ffca:29c4:6488])
        by smtp.googlemail.com with ESMTPSA id 13sm24056349pfi.78.2020.02.04.07.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 07:28:41 -0800 (PST)
Subject: Re: [PATCH RFC 10/10] nvdimm/e820: add multiple namespaces support
To:     Joao Martins <joao.m.martins@oracle.com>, linux-nvdimm@lists.01.org
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-11-joao.m.martins@oracle.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <e605fed8-46f5-6a07-11e6-2cc079a1159b@google.com>
Date:   Tue, 4 Feb 2020 10:28:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200110190313.17144-11-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi -

On 1/10/20 2:03 PM, Joao Martins wrote:
> User can define regions with 'memmap=size!offset' which in turn
> creates PMEM legacy devices. But because it is a label-less
> NVDIMM device we only have one namespace for the whole device.
> 
> Add support for multiple namespaces by adding ndctl control
> support, and exposing a minimal set of features:
> (ND_CMD_GET_CONFIG_SIZE, ND_CMD_GET_CONFIG_DATA,
> ND_CMD_SET_CONFIG_DATA) alongside NDD_ALIASING because we can
> store labels.

FWIW, I like this a lot.  If we move away from using memmap in favor of 
efi_fake_mem, ideally we'd have the same support for full-fledged 
pmem/dax regions and namespaces that this patch brings.

Thanks,
Barret


> 
> Initialization is a little different: We allocate and register an
> nvdimm bus with an @nvdimm_descriptor which we use to locate
> where we are keeping our label storage area. The config data
> get/set/size operations are then simply memcpying to this area.
> 
> Equivalent approach can also be found in the NFIT tests which
> emulate the same thing.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/nvdimm/e820.c | 212 +++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 191 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/nvdimm/e820.c b/drivers/nvdimm/e820.c
> index e02f60ad6c99..36fbff3d7110 100644
> --- a/drivers/nvdimm/e820.c
> +++ b/drivers/nvdimm/e820.c
> @@ -7,14 +7,21 @@
>   #include <linux/memory_hotplug.h>
>   #include <linux/libnvdimm.h>
>   #include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/ndctl.h>
> +#include <linux/nd.h>
>   
> -static int e820_pmem_remove(struct platform_device *pdev)
> -{
> -	struct nvdimm_bus *nvdimm_bus = platform_get_drvdata(pdev);
> +#define LABEL_SIZE SZ_128K
>   
> -	nvdimm_bus_unregister(nvdimm_bus);
> -	return 0;
> -}
> +struct e820_descriptor {
> +	struct nd_interleave_set nd_set;
> +	struct nvdimm_bus_descriptor nd_desc;
> +	void *label;
> +	unsigned char cookie1[16];
> +	unsigned char cookie2[16];
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct nvdimm *nvdimm;
> +};
>   
>   #ifdef CONFIG_MEMORY_HOTPLUG
>   static int e820_range_to_nid(resource_size_t addr)
> @@ -28,43 +35,206 @@ static int e820_range_to_nid(resource_size_t addr)
>   }
>   #endif
>   
> +static int e820_get_config_size(struct nd_cmd_get_config_size *nd_cmd,
> +				unsigned int buf_len)
> +{
> +	if (buf_len < sizeof(*nd_cmd))
> +		return -EINVAL;
> +
> +	nd_cmd->status = 0;
> +	nd_cmd->config_size = LABEL_SIZE;
> +	nd_cmd->max_xfer = SZ_4K;
> +
> +	return 0;
> +}
> +
> +static int e820_get_config_data(struct nd_cmd_get_config_data_hdr
> +		*nd_cmd, unsigned int buf_len, void *label)
> +{
> +	unsigned int len, offset = nd_cmd->in_offset;
> +	int rc;
> +
> +	if (buf_len < sizeof(*nd_cmd))
> +		return -EINVAL;
> +	if (offset >= LABEL_SIZE)
> +		return -EINVAL;
> +	if (nd_cmd->in_length + sizeof(*nd_cmd) > buf_len)
> +		return -EINVAL;
> +
> +	nd_cmd->status = 0;
> +	len = min(nd_cmd->in_length, LABEL_SIZE - offset);
> +	memcpy(nd_cmd->out_buf, label + offset, len);
> +	rc = buf_len - sizeof(*nd_cmd) - len;
> +
> +	return rc;
> +}
> +
> +static int e820_set_config_data(struct nd_cmd_set_config_hdr *nd_cmd,
> +		unsigned int buf_len, void *label)
> +{
> +	unsigned int len, offset = nd_cmd->in_offset;
> +	u32 *status;
> +	int rc;
> +
> +	if (buf_len < sizeof(*nd_cmd))
> +		return -EINVAL;
> +	if (offset >= LABEL_SIZE)
> +		return -EINVAL;
> +	if (nd_cmd->in_length + sizeof(*nd_cmd) + 4 > buf_len)
> +		return -EINVAL;
> +
> +	status = (void *)nd_cmd + nd_cmd->in_length + sizeof(*nd_cmd);
> +	*status = 0;
> +	len = min(nd_cmd->in_length, LABEL_SIZE - offset);
> +	memcpy(label + offset, nd_cmd->in_buf, len);
> +	rc = buf_len - sizeof(*nd_cmd) - (len + 4);
> +
> +	return rc;
> +}
> +
> +static struct e820_descriptor *to_e820_desc(struct nvdimm_bus_descriptor *desc)
> +{
> +	return container_of(desc, struct e820_descriptor, nd_desc);
> +}
> +
> +static int e820_ndctl(struct nvdimm_bus_descriptor *nd_desc,
> +			 struct nvdimm *nvdimm, unsigned int cmd, void *buf,
> +			 unsigned int buf_len, int *cmd_rc)
> +{
> +	struct e820_descriptor *t = to_e820_desc(nd_desc);
> +	int rc = -EINVAL;
> +
> +	switch (cmd) {
> +	case ND_CMD_GET_CONFIG_SIZE:
> +		rc = e820_get_config_size(buf, buf_len);
> +		break;
> +	case ND_CMD_GET_CONFIG_DATA:
> +		rc = e820_get_config_data(buf, buf_len, t->label);
> +		break;
> +	case ND_CMD_SET_CONFIG_DATA:
> +		rc = e820_set_config_data(buf, buf_len, t->label);
> +		break;
> +	default:
> +		return rc;
> +	}
> +
> +	return rc;
> +}
> +
> +static void e820_desc_free(struct e820_descriptor *desc)
> +{
> +	if (!desc)
> +		return;
> +
> +	nvdimm_bus_unregister(desc->nvdimm_bus);
> +	kfree(desc->label);
> +	kfree(desc);
> +}
> +
> +static struct e820_descriptor *e820_desc_alloc(struct platform_device *pdev)
> +{
> +	struct nvdimm_bus_descriptor *nd_desc;
> +	unsigned int cmd_mask, dimm_flags;
> +	struct device *dev = &pdev->dev;
> +	struct nvdimm_bus *nvdimm_bus;
> +	struct e820_descriptor *desc;
> +	struct nvdimm *nvdimm;
> +
> +	desc = kzalloc(sizeof(*desc), GFP_KERNEL);
> +	if (!desc)
> +		goto err;
> +
> +	desc->label = kzalloc(LABEL_SIZE, GFP_KERNEL);
> +	if (!desc->label)
> +		goto err;
> +
> +	nd_desc = &desc->nd_desc;
> +	nd_desc->provider_name = "e820";
> +	nd_desc->module = THIS_MODULE;
> +	nd_desc->ndctl = e820_ndctl;
> +	nvdimm_bus = nvdimm_bus_register(&pdev->dev, nd_desc);
> +	if (!nvdimm_bus) {
> +		dev_err(dev, "nvdimm bus registration failure\n");
> +		goto err;
> +	}
> +	desc->nvdimm_bus = nvdimm_bus;
> +
> +	cmd_mask = (1UL << ND_CMD_GET_CONFIG_SIZE |
> +			1UL << ND_CMD_GET_CONFIG_DATA |
> +			1UL << ND_CMD_SET_CONFIG_DATA);
> +	dimm_flags = (1UL << NDD_ALIASING);
> +	nvdimm = nvdimm_create(nvdimm_bus, pdev, NULL,
> +				dimm_flags, cmd_mask, 0, NULL);
> +	if (!nvdimm) {
> +		dev_err(dev, "nvdimm creation failure\n");
> +		goto err;
> +	}
> +	desc->nvdimm = nvdimm;
> +	return desc;
> +
> +err:
> +	e820_desc_free(desc);
> +	return NULL;
> +}
> +
>   static int e820_register_one(struct resource *res, void *data)
>   {
> +	struct platform_device *pdev = data;
>   	struct nd_region_desc ndr_desc;
> -	struct nvdimm_bus *nvdimm_bus = data;
> +	struct nd_mapping_desc mapping;
> +	struct e820_descriptor *desc;
> +
> +	desc = e820_desc_alloc(pdev);
> +	if (!desc)
> +		return -ENOMEM;
> +
> +	mapping.nvdimm = desc->nvdimm;
> +	mapping.start = res->start;
> +	mapping.size = resource_size(res);
> +	mapping.position = 0;
> +
> +	generate_random_uuid(desc->cookie1);
> +	desc->nd_set.cookie1 = (u64) desc->cookie1;
> +	generate_random_uuid(desc->cookie2);
> +	desc->nd_set.cookie2 = (u64) desc->cookie2;
>   
>   	memset(&ndr_desc, 0, sizeof(ndr_desc));
>   	ndr_desc.res = res;
>   	ndr_desc.numa_node = e820_range_to_nid(res->start);
>   	ndr_desc.target_node = ndr_desc.numa_node;
> +	ndr_desc.mapping = &mapping;
> +	ndr_desc.num_mappings = 1;
> +	ndr_desc.nd_set = &desc->nd_set;
>   	set_bit(ND_REGION_PAGEMAP, &ndr_desc.flags);
> -	if (!nvdimm_pmem_region_create(nvdimm_bus, &ndr_desc))
> +	if (!nvdimm_pmem_region_create(desc->nvdimm_bus, &ndr_desc)) {
> +		e820_desc_free(desc);
> +		dev_err(&pdev->dev, "nvdimm region creation failure\n");
>   		return -ENXIO;
> +	}
> +
> +	platform_set_drvdata(pdev, desc);
> +	return 0;
> +}
> +
> +static int e820_pmem_remove(struct platform_device *pdev)
> +{
> +	struct e820_descriptor *desc = platform_get_drvdata(pdev);
> +
> +	e820_desc_free(desc);
>   	return 0;
>   }
>   
>   static int e820_pmem_probe(struct platform_device *pdev)
>   {
> -	static struct nvdimm_bus_descriptor nd_desc;
> -	struct device *dev = &pdev->dev;
> -	struct nvdimm_bus *nvdimm_bus;
>   	int rc = -ENXIO;
>   
> -	nd_desc.provider_name = "e820";
> -	nd_desc.module = THIS_MODULE;
> -	nvdimm_bus = nvdimm_bus_register(dev, &nd_desc);
> -	if (!nvdimm_bus)
> -		goto err;
> -	platform_set_drvdata(pdev, nvdimm_bus);
> -
>   	rc = walk_iomem_res_desc(IORES_DESC_PERSISTENT_MEMORY_LEGACY,
> -			IORESOURCE_MEM, 0, -1, nvdimm_bus, e820_register_one);
> +			IORESOURCE_MEM, 0, -1, pdev, e820_register_one);
>   	if (rc)
>   		goto err;
>   	return 0;
>   err:
> -	nvdimm_bus_unregister(nvdimm_bus);
> -	dev_err(dev, "failed to register legacy persistent memory ranges\n");
> +	dev_err(&pdev->dev, "failed to register legacy persistent memory ranges\n");
>   	return rc;
>   }
>   
> 

