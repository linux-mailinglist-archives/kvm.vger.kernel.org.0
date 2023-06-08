Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F89D727B17
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 11:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235248AbjFHJVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 05:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjFHJVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 05:21:07 -0400
X-Greylist: delayed 537 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Jun 2023 02:21:05 PDT
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081B418F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 02:21:04 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 36899100F00EE;
        Thu,  8 Jun 2023 11:12:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 00322D4F60; Thu,  8 Jun 2023 11:12:02 +0200 (CEST)
Date:   Thu, 8 Jun 2023 11:12:02 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        "Giani, Dhaval" <Dhaval.Giani@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kardashevskiy, Alexey" <Alexey.Kardashevskiy@amd.com>,
        "Kaplan, David" <David.Kaplan@amd.com>,
        "steffen.eiden@ibm.com" <steffen.eiden@ibm.com>,
        "yilun.xu@intel.com" <yilun.xu@intel.com>,
        Suzuki K P <suzuki.kp@gmail.com>,
        "Powell, Jeremy" <Jeremy.Powell@amd.com>,
        "atishp04@gmail.com" <atishp04@gmail.com>,
        "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: RE: KVM Forum BoF on I/O + secure virtualization
Message-ID: <20230608091202.GA962@wunner.de>
References: <c2db1a80-722b-c807-76b5-b8672cb0db09@redhat.com>
 <MW4PR12MB7213E05A15C3F45CA6F9E93B8D4EA@MW4PR12MB7213.namprd12.prod.outlook.com>
 <647e9d4be14dd_142af8294b2@dwillia2-xfh.jf.intel.com.notmuch>
 <d1269899-7e74-f33c-97bf-be0c708d2465@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1269899-7e74-f33c-97bf-be0c708d2465@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[cc += Jonathan, Sean]

On Thu, Jun 08, 2023 at 09:18:12AM +1000, Alexey Kardashevskiy wrote:
> On 6/6/23 12:43, Dan Williams wrote:
> > Giani, Dhaval wrote:
> > > We have proposed a trusted I/O BoF session at KVM forum this year.
> > > I wanted to kick off the discussion to maximize the 25 mins we have.
> > > 
> > > By trusted I/O, I mean using TDISP to have "trusted" communications
> > > with a device using something like AMD SEV-TIO [1] or Intel's
> > > TDX connect [2].
> > > 
> > > Some topics we would like to discuss are
> > > o What is the device model like?
> > > o Do we enlighten the PCI subsystem?
> > > o Do we enlighten device drivers?
> > 
> > One observation in relation to these first questions is something that
> > has been brewing since SPDM and IDE were discussed at Plumbers 2022.
> > 
> > https://lpc.events/event/16/contributions/1304/
> > 
> > Namely, that there is value in the base specs on the way to the full
> > vendor TSM implementations. I.e. that if the Linux kernel can aspire to
> > the role of a TSM it becomes easier to incrementally add proxying to a
> > platform TSM later. In the meantime, platforms and endpoints that
> > support CMA / SPDM and PCIe/CXL IDE but not full "trusted I/O" still
> > gain incremental benefit.
> 
> TSM on the AMD hardware is a PSP firmware and it is going to implement all
> of SPDM/IDE and the only proxying the host kernel will do is PCI DOE.

Sean has voiced a scathing critique of this model where a firmware does
all the attestation and hence needs to be trusted:

https://lore.kernel.org/all/Y+aP8rHr6H3LIf%2Fc@google.com/
https://lore.kernel.org/all/ZEfrjtgGgm1lpadq@google.com/

I think we need to entertain the idea that Linux does the attestation
and encryption setup itself.  Reliance on a "trusted" hardware module
should be optional.

That also works for KVM:  The guest can perform attestation on its own
behalf, setup encryption and drive the TDISP state machine.  If the
guest's memory is encrypted with SEV or TDX, the IDE keys generated by
the guest are invisible to the VMM and hence confidentiality is achieved.
The guest can communicate the keys securely to the device via IDE_KM and
the guest can ask the device to lock down via TDISP.

Yes, the guest may need to rely on the PSP firmware to program the
IDE key into the Root Port.  Can you provide that as a service from
the PSP firmware?

What you seem to be arguing for is a "fat" firmware which does all
the attestation.  The host kernel is relegated to being a mere DOE proxy.
And the guest is relegated to being a "dumb" receiver of the firmware's
attestation results.

What I'm arguing for is a "thin" firmware which provides a minimized
set of services (such as selecting a free IDE stream in the Root Port
and writing keys into it).

The host kernel can perform attestation and set up encryption for
devices it wants to use itself.  Once it passes through a device to
a guest, the host kernel no longer performs any SPDM exchanges with
the device as it's now owned by the guest.  The guest is responsible
for performing attestation and set up encryption for itself, possibly
with the help of firmware.

If there is no firmware to program IDE keys into the Root Port,
the guest must ask the VMM to do that.  The VMM then becomes part
of the guest's TCB, but that trade-off is unavoidable if there's
no firmware assistance.  Some customers (such as Sean) seem to
prefer that to trusting a vendor-provided firmware.

Remember, this must work for everyone, not just for people who are
happy with AMD's and Intel's shrink-wrapped offerings.

We can discuss an _OSC bit to switch between firmware-driven attestation
and OS-native attestation, similar to the existing bits for PCIe hotplug,
DPC etc.

However, past experience with firmware-handled hotplug and DPC has
generally been negative and I believe most everyone is preferring the
OS-native variant nowadays.  The OS has a better overall knowledge of
the system state than the firmware.  E.g. the kernel can detect hotplug
events caused by DPC and ignore them (see commit a97396c6eb13).

Similarly, the CMA-SPDM patches I'm working on reauthenticate devices
after a DPC-induced Hot Reset or after resume from D3cold.  I imagine
it may be difficult to achieve the same if attestation is handled by
firmware.

I'm talking about commit "PCI/CMA: Reauthenticate devices on reset and
resume" on this development branch:

https://github.com/l1k/linux/commits/doe

Thanks,

Lukas

> > The first proof point for that idea is teaching the PCI core to perform
> > CMA / SPDM session establishment and provide that result to drivers.
> > 
> > That is what Lukas has been working on after picking up Jonathan's
> > initial SPDM RFC. I expect the discussion on those forthcoming patches
> > starts to answer device-model questions around attestation.
> 
> Those SPDM patches should work on the AMD hw (as they do not need any
> additional host PCI support) but that's about it - IDE won't be possible
> that way as there is no way to program the IDE keys to PCI RC without the
> PSP.
> 
> If we want reuse any of that code to provide
> certificates/measurements/reports for the host kernel, then that will need
> to allow skipping the bits that the firmware implements (SPDM, IDE) +
> calling the firmware instead. And TDISP is worse as it is based on the idea
> of not trusting the VMM (is there any use for TDISP for the host-only config
> at all?) so such SPDM-enabled linux has to not run KVM.
> 
> > > o What does the guest need to know from the device?
> > > o How does the attestation workflow work?
> > > o Generic vs vendor specific TSMs
> > > 
> > > Some of these topics may be better suited for LPC,
> > 
> > Maybe, but there's so much to discuss that the more opportunities to
> > collaborate on the details the better.
> > 
> > > however we want to get the discussion going from the KVM perspective
> > > and continue wider discussions at LPC.
> > 
> > While I worry that my points above are more suited to something like a
> > PCI Micro-conference than a KVM BoF, I think the nature of "trusted I/O"
> > requires those tribes to talk more to each other.
