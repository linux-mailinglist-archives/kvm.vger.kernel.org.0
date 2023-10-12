Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3377C6427
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 06:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376937AbjJLEhq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 00:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbjJLEho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 00:37:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B12A9;
        Wed, 11 Oct 2023 21:37:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC85C433C8;
        Thu, 12 Oct 2023 04:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697085460;
        bh=WKRKh0vu+lvGkILyFkc21Gg7NJFJdo31kGHt149b6Yw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=O2ZXpXd3qxrWT/U+L5Vg2+ZMY020MyCEIEfTRnWCs10Q47+Edcf1eUfbKNceFn18X
         GXn9+C1E3xDY9eSK8PirTh2Sh8AEdkDHUgt4D1X23uyPuxUAo3E0PbawhXUnKa8afZ
         wWFGRyqfZ3b0jXoDyJSAb/YoTB4QxXTIUok7R6dQqISYXGUarEehor/V6vSTIYExa/
         OkRBbIjSvxucQ1DBgn2gsGiQRy8MxHp9cnyhWuKur1R8VZ7MZdLKlIUiJeZHq41gdg
         zS+kLzAgEWw2O+K8k09av3yyOllgdil5akGob/T7C2x7G2U2dxg7+i/Nz/21BV51Ln
         nKJq7hBNkqfvw==
Message-ID: <0340908d-8d23-4553-be46-50bab7fe053a@kernel.org>
Date:   Thu, 12 Oct 2023 13:37:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] spdm: Introduce library to authenticate devices
Content-Language: en-US
To:     Alistair Francis <Alistair.Francis@wdc.com>,
        "Jonathan.Cameron@Huawei.com" <Jonathan.Cameron@Huawei.com>,
        "lukas@wunner.de" <lukas@wunner.de>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ming4.li@intel.com" <ming4.li@intel.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "zhi.a.wang@intel.com" <zhi.a.wang@intel.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "dave.jiang@intel.com" <dave.jiang@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "aik@amd.com" <aik@amd.com>,
        "david.e.box@intel.com" <david.e.box@intel.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
References: <cover.1695921656.git.lukas@wunner.de>
 <89a83f42ae3c411f46efd968007e9b2afd839e74.1695921657.git.lukas@wunner.de>
 <20231003153937.000034ca@Huawei.com>
 <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <caf11c28d21382cc1a81d84a23cbca9e70805a87.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/23 12:26, Alistair Francis wrote:
> On Tue, 2023-10-03 at 15:39 +0100, Jonathan Cameron wrote:
>> On Thu, 28 Sep 2023 19:32:37 +0200
>> Lukas Wunner <lukas@wunner.de> wrote:
>>
>>> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>>>
>>> The Security Protocol and Data Model (SPDM) allows for
>>> authentication,
>>> measurement, key exchange and encrypted sessions with devices.
>>>
>>> A commonly used term for authentication and measurement is
>>> attestation.
>>>
>>> SPDM was conceived by the Distributed Management Task Force (DMTF).
>>> Its specification defines a request/response protocol spoken
>>> between
>>> host and attached devices over a variety of transports:
>>>
>>>   https://www.dmtf.org/dsp/DSP0274
>>>
>>> This implementation supports SPDM 1.0 through 1.3 (the latest
>>> version).
>>
>> I've no strong objection in allowing 1.0, but I think we do need
>> to control min version accepted somehow as I'm not that keen to get
>> security folk analyzing old version...
> 
> Agreed. I'm not sure we even need to support 1.0
> 
>>
>>> It is designed to be transport-agnostic as the kernel already
>>> supports
>>> two different SPDM-capable transports:
>>>
>>> * PCIe Data Object Exchange (PCIe r6.1 sec 6.30, drivers/pci/doe.c)
>>> * Management Component Transport Protocol (MCTP,
>>>   Documentation/networking/mctp.rst)
>>
>> The MCTP side of things is going to be interesting because mostly you
>> need to jump through a bunch of hoops (address assignment, routing
>> setup
>> etc) before you can actually talk to a device.   That all involves
>> a userspace agent.  So I'm not 100% sure how this will all turn out.
>> However still makes sense to have a transport agnostic implementation
>> as if nothing else it makes it easier to review as keeps us within
>> one specification.
> 
> This list will probably expand in the future though
> 
>>>
>>> Use cases for SPDM include, but are not limited to:
>>>
>>> * PCIe Component Measurement and Authentication (PCIe r6.1 sec
>>> 6.31)
>>> * Compute Express Link (CXL r3.0 sec 14.11.6)
>>> * Open Compute Project (Attestation of System Components r1.0)
>>>  
>>> https://www.opencompute.org/documents/attestation-v1-0-20201104-pdf
>>
>> Alastair, would it make sense to also call out some of the storage
>> use cases you are interested in?
> 
> I don't really have anything to add at the moment. I think PCIe CMA
> covers the current DOE work

Specifications for SPDM encapsulation in SCSI and ATA commands (SECURITY
PROTOCOL IN/OUT and TRUSTED SNED/RECEIVE) is being worked on now but that is
still in early phases of definition. So that support can come later. I suspect
the API may need some modification to accommodate that use case, but we need
more complete specification first to clearly see what is needed (if anything at
all).


-- 
Damien Le Moal
Western Digital Research

