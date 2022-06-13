Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532E7549D92
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 21:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349261AbiFMTYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 15:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350295AbiFMTXZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 15:23:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5C34BF71;
        Mon, 13 Jun 2022 10:20:27 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9632D23A;
        Mon, 13 Jun 2022 10:20:27 -0700 (PDT)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0F6B23F792;
        Mon, 13 Jun 2022 10:20:25 -0700 (PDT)
Date:   Mon, 13 Jun 2022 18:20:15 +0100
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc:     mst@redhat.com, jasowang@redhat.com, sudeep.holla@arm.com,
        quic_sramana@quicinc.com, vincent.guittot@linaro.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Souvik Chakravarty <Souvik.Chakravarty@arm.com>
Subject: Re: [RFC 0/3] SCMI Vhost and Virtio backend implementation
Message-ID: <Yqdxz9lZo5qedTG4@e120937-lin>
References: <20220609071956.5183-1-quic_neeraju@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609071956.5183-1-quic_neeraju@quicinc.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+CC: Souvik

On Thu, Jun 09, 2022 at 12:49:53PM +0530, Neeraj Upadhyay wrote:
> This RFC series, provides ARM System Control and Management Interface (SCMI)
> protocol backend implementation for Virtio transport. The purpose of this

Hi Neeraj,

Thanks for this work, I only glanced through the series at first to
grasp a general understanding of it (without goind into much details for
now) and I'd have a few questions/concerns that I'll noted down below.

I focused mainly on the backend server aims/functionalities/issues ignoring
at first the vhost-scmi entry-point since the vost-scmi accelerator is just
a (more-or-less) standard means of configuring and grabbing SCMI traffic
from the VMs into the Host Kernel and so I found more interesting at first
to understand what we can do with such traffic at first.
(IOW the vhost-scmi layer is welcome but remain to see what to do with it...)

> feature is to provide para-virtualized interfaces to guest VMs, to various
> hardware blocks like clocks, regulators. This allows the guest VMs to
> communicate their resource needs to the host, in the absence of direct
> access to those resources.

In an SCMI stack the agents (like VMs) issue requests to an SCMI platform
backend that is in charge of policying and armonizing such requests
eventually denying some of these (possibly malicious) while allowing others
(possibly armonizing/merging such reqs); with your solution basically the
SCMI backend in Kernel marshals/conveys all of such SCMI requests to the
proper Linux Kernel subsystem that is usually in charge of it, using
dedicated protocol handlers that basically translates SCMI requests to
Linux APIs calls to the Host. (I may have oversimplified or missed
something...)

At the price of a bit of overhead and code-duplication introduced by
this SCMI Backend you can indeed leverage the existing mechanisms for
resource accounting and sharing included in such Linux subsystems (like
Clock framework), and that's nice and useful, BUT how do you policy/filter
(possibly dinamically as VMs come and go) what these VMs can see and do
with these resources ?

... MORE importantly how do you protect the Host (or another VM) from
unacceptable (or possibly malicious) requests conveyed from one VM request
vqueue into the Linux subsystems (like clocks) ?

I saw you have added a good deal of DT bindings for the backend
describing protocols, so you could just expose only some protocols via
the backend (if I get it right) but you cannot anyway selectively expose
only a subset of resources to the different agents, so, if you expose the
clock protocol, that will be visible by any VMs and an agent could potentially
kill the Host or mount some clock related attack acting on the right clock.
(I mean you cannot describe in the Host DT a number X of clocks to be
supported by the Host Linux Clock framework BUT then expose selectively to
the SCMI agents only a subset Y < X to shield the Host from misbehaviour...
...at least not in a dynamic way avoiding to bake a fixed policy into
the backend...or maybe I'm missing how you can do that, in such a case
please explain...)

Moreover, in a normal SCMI stack the server resides out of reach from the
OSPM agents since the server, wherever it sits, has the last word and can
deny and block unreasonable/malicious requests while armonizing others: this
means the typical SCMI platform fw is configured in such a way that clearly
defines a set of policies to be enforced between the access of the various
agents. (and it can reside in the trusted codebase given its 'reduced'
size...even though this policies are probably at the moment not so
dynamically modificable there either...)

With your approach of a Linux Kernel based SCMI platform backend you are
certainly using all the good and well proven mechanisms offered by the
Kernel to share and co-ordinate access to such resources, which is good
(.. even though Linux is not so small in term of codebase to be used as
a TCB to tell the truth :D), BUT I don't see the same level of policying
or filtering applied anywhere in the proposed RFCs, especially to protect
the Host which at the end is supposed to use the same Linux subsystems and
possibly share some of those resources for its own needs.

I saw the Base protocol basic implementation you provided to expose the
supported backend protocols to the VMs, it would be useful to see how
you plan to handle something like the Clock protocol you mention in the
example below. (if you have Clock protocol backend that as WIP already
would be interesting to see it...)

Another issue/criticality that comes to my mind is how do you gather in
general basic resources states/descriptors from the existing Linux subsystems
(even leaving out any policying concerns): as an example, how do you gather
from the Host Clock framework the list of available clocks and their rates
descriptors that you're going expose to a specific VMs once this latter will
issue the related SCMI commands to get to know which SCMI Clock domain are
available ?
(...and I mean in a dynamic way not using a builtin per-platform baked set of
 resources known to be made available... I doubt that any sort of DT
 description would be accepted in this regards ...)

> 
> 1. Architecture overview
> ---------------------
> 
> Below diagram shows the overall software architecture of SCMI communication
> between guest VM and the host software. In this diagram, guest is a linux
> VM; also, host uses KVM linux.
> 
>          GUEST VM                   HOST
>  +--------------------+    +---------------------+    +--------------+
>  |   a. Device A      |    |   k. Device B       |    |      PLL     |
>  |  (Clock consumer)  |    |  (Clock consumer)   |    |              |
>  +--------------------+    +---------------------+    +--------------+
>           |                         |                         ^
>           v                         v                         |
>  +--------------------+    +---------------------+    +-----------------+
>  | b. Clock Framework |    | j. Clock Framework  | -->| l. Clock Driver |
>  +-- -----------------+    +---------------------+    +-----------------+
>           |                         ^
>           v                         |
>  +--------------------+    +------------------------+
>  |  c. SCMI Clock     |    | i. SCMI Virtio Backend |
>  +--------------------+    +------------------------+ 
>           |                         ^
>           v                         |
>  +--------------------+    +----------------------+
>  |  d. SCMI Virtio    |    |   h. SCMI Vhost      |<-----------+
>  +--------------------+    +----------------------+            |
>           |                         ^                          |
>           v                         |                          |
> +-------------------------------------------------+    +-----------------+
> |              e. Virtio Infra                    |    |    g. VMM       |
> +-------------------------------------------------+    +-----------------+
>           |                         ^                           ^
>           v                         |                           |
> +-------------------------------------------------+             |
> |                f. Hypervisor                    |-------------
> +-------------------------------------------------+
> 

Looking at the above schema and thinking out loud where any dynamic
policying against the resources can fit (..and trying desperately NOT to push
that into the Kernel too :P...) ... I think that XEN was trying something similar
(with a real backend SCMI platform FW at the end of the pipe though I think...) and
in their case the per-VMs resource allocation was performed using SCMI
BASE_SET_DEVICE_PERMISSIONS commands issued by the Hypervisor/VMM itself
I think or by a Dom0 elected as a trusted agent and so allowed to configure
such resource partitioning ...

https://www.mail-archive.com/xen-devel@lists.xenproject.org/msg113868.html

...maybe a similar approach, with some sort of SCMI Trusted Agent living within
the VMM and in charge of directing such resources' partitioning between
VMs by issuing BASE_SET_DEVICE_PERMISSIONS towards the Kernel SCMI Virtio
Backend, could help keeping at least the policy bits related to the VMs out of
the kernel/DTs and possibly dynamically configurable following VMs lifecycle.

Even though, in our case ALL the resource management by device ID would have to
happen in the Kernel SCMI backend at the end, given that is where the SCMI
platform resides indeed, BUT at least you could keep the effective policy out of
kernel space, doing something like:

1. VMM/TrustedAgent query Kernel_SCMI_Virtio_backend for available resources

2. VMM/TrustedAg decides resources allocation between VMs (and/or possibly the Host
   based on some configured policy)

3. VMM/TrustedAgent issues BASE_SET_DEVICE_PERMISSIONS/PROTOCOLS to the
   Kernel_SCMI_Virtio_backend

4. Kernel_SCMI_Virtio_backend enforces resource partioning and sharing
   when processing subsequent VMs SCMI requests coming via Vhost-SCMI

...where the TrustedAgent here could be (I guess) the VMM or the Host or
both with different level of privilege if you don't want the VMM to be able
to configure resources access for the whole Host.

> a. Device A             This is the client kernel driver in guest VM,
>                         for ex. diplay driver, which uses standard
>                         clock framework APIs to vote for a clock.
> 
> b. Clock Framework      Underlying kernel clock framework on
>                         guest.
> 
> c. SCMI Clock           SCMI interface based clock driver.
> 
> d. SCMI Virtio          Underlying SCMI framework, using Virtio as
>                         transport driver.
> 
> e. Virtio Infra         Virtio drivers on guest VM. These drivers
>                         initiate virtqueue requests over Virtio
>                         transport (MMIO/PCI), and forwards response
>                         to SCMI Virtio registered callbacks.
> 
> f. Hypervisor           Hosted Hypervisor (KVM for ex.), which traps
>                         and forwards requests on virtqueue ring
>                         buffers to the VMM.
> 
> g. VMM                  Virtual Machine Monitor, running on host userspace,
>                         which manages the lifecycle of guest VMs, and forwards
>                         guest initiated virtqueue requests as IOCTLs to the
>                         Vhost driver on host.
> 
> h. SCMI Vhost           In kernel driver, which handles SCMI virtqueue
>                         requests from guest VMs. This driver forwards the
>                         requests to SCMI Virtio backend driver, and returns
>                         the response from backend, over the virtqueue ring
>                         buffers.
> 
> i. SCMI Virtio Backend  SCMI backend, which handles the incoming SCMI messages
>                         from SCMI Vhost driver, and forwards them to the
>                         backend protocols like clock and voltage protocols.
>                         The backend protocols uses the host apis for those
>                         resources like clock APIs provided by clock framework,
>                         to vote/request for the resource. The response from
>                         the host api is parceled into a SCMI response message,
>                         and is returned to the SCMI Vhost driver. The SCMI
>                         Vhost driver in turn, returns the reponse over the
>                         Virtqueue reponse buffers.
> 

Last but not least, this SCMI Virtio Backend layer in charge of
processing incoming SCMI packets, interfacing with the Linux subsystems
final backend and building SCMI replies from Linux will introduce a
certain level of code/funcs duplication given that this same SCMI basic
processing capabilities have been already baked in the SCMI stacks found in
SCP and in TF-A (.. and maybe a few other other proprietary backends)...

... but this is something maybe to be addressed in general in a
different context not something that can be addressed by this series.

Sorry for the usual flood of words :P ... I'll have a more in deep
review of the series in the next days, for now I wanted just to share my
concerns and (maybe wrong) understanding and see what you or Sudeep and
Souvik think about.

Thanks,
Cristian

