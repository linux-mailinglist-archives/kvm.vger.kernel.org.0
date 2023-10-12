Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB6F77C718D
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379373AbjJLPc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347298AbjJLPc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:32:28 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7769ED3;
        Thu, 12 Oct 2023 08:32:25 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S5tqt2GDkz6K5yD;
        Thu, 12 Oct 2023 23:30:18 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Thu, 12 Oct
 2023 16:32:22 +0100
Date:   Thu, 12 Oct 2023 16:32:21 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Samuel Ortiz <sameo@rivosinc.com>
CC:     Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy <aik@amd.com>,
        "Dan Williams" <dan.j.williams@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        "Alistair Francis" <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Sean Christopherson" <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 00/12] PCI device authentication
Message-ID: <20231012163221.000064af@Huawei.com>
In-Reply-To: <ZSfw+xswgOSaYxgW@vermeer>
References: <cover.1695921656.git.lukas@wunner.de>
        <652030759e42d_ae7e72946@dwillia2-xfh.jf.intel.com.notmuch>
        <20231007100433.GA7596@wunner.de>
        <20231009123335.00006d3d@Huawei.com>
        <20231009134950.GA7097@wunner.de>
        <b003c0ca-b5c7-4082-a391-aeb04ccc33ca@amd.com>
        <20231012091542.GA22596@wunner.de>
        <ZSfw+xswgOSaYxgW@vermeer>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500004.china.huawei.com (7.191.163.9) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 12 Oct 2023 15:13:31 +0200
Samuel Ortiz <sameo@rivosinc.com> wrote:

> On Thu, Oct 12, 2023 at 11:15:42AM +0200, Lukas Wunner wrote:
> > On Tue, Oct 10, 2023 at 03:07:41PM +1100, Alexey Kardashevskiy wrote:  
> > > But the way SPDM is done now is that if the user (as myself) wants to let
> > > the firmware run SPDM - the only choice is disabling CONFIG_CMA completely
> > > as CMA is not a (un)loadable module or built-in (with some "blacklist"
> > > parameters), and does not provide a sysfs knob to control its tentacles.
> > > Kinda harsh.  
> > 
> > On AMD SEV-TIO, does the PSP perform SPDM exchanges with a device
> > *before* it is passed through to a guest?  If so, why does it do that?  
> 
> SPDM exchanges would be done with the DSM, i.e. through the PF, which is
> typically *not* passed through to guests. VFs are.
> 
> The RISC-V CoVE-IO [1] spec follows similar flows as SEV-TIO (and to
> some extend TDX-Connect) and expects the host to explicitly request the
> TSM to establish an SPDM connection with the DSM (PF) before passing one
> VF through a TSM managed guest. VFs would be vfio bound, not the PF, so
> I think patch #12 does not solve our problem here. 
> 
> > Dan and I discussed this off-list and Dan is arguing for lazy attestation,
> > i.e. the TSM should only have the need to perform SPDM exchanges with
> > the device when it is passed through.
> > 
> > So the host enumerates the DOE protocols and authenticates the device.
> > When the device is passed through, patch 12/12 ensures that the host
> > keeps its hands off of the device, thus affording the TSM exclusive
> > SPDM control.  
> 
> Just to re-iterate: The TSM does not talk SPDM with the passed
> through device(s), but with the corresponding PF. If the host kernel
> owns the SPDM connection when the TSM initiates the SPDM connection with
> the DSM (For IDE key setup), the connection establishment will fail.
> Both CoVE-IO and SEV-TIO (Alexey, please correct me if I'm wrong)
> expect the host to explicitly ask the TSM to establish that SPDM
> connection. That request should somehow come from KVM, which then would
> have to destroy the existing CMA/SPDM connection in order to give the
> TSM a chance to successfully establish the SPDM link.

Agreed - I don't see a problem with throwing away the initial connection.
In these cases you are passing that role on to another entity - the
job of this patch set is done.

I'm not clear yet if we need an explicit lock out similar to the VFIO
one for PF pass through or if everything will happen in a 'safe' order
anyway. I suspect a lockout on the ability to re attest is necessary
if the PF driver is loaded.

Perhaps just dropping the
+#if IS_ENABLED(CONFIG_VFIO_PCI_CORE)
and letting other PF drivers or another bit of core kernel code
(I'm not sure where the proxy resides for the models being discussed)
claim ownership is enough?

Jonathan

> 
> Cheers,
> Samuel.
> 
> [1] https://github.com/riscv-non-isa/riscv-ap-tee-io/blob/main/specification/07-theory_operations.adoc
> >   
> 

