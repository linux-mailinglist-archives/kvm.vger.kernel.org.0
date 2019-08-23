Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783359B7DB
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 22:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392601AbfHWUso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 16:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388903AbfHWUso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 16:48:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16D673C919;
        Fri, 23 Aug 2019 20:48:44 +0000 (UTC)
Received: from x1.home (ovpn-116-99.phx2.redhat.com [10.3.116.99])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 999DF5D6B2;
        Fri, 23 Aug 2019 20:48:43 +0000 (UTC)
Date:   Fri, 23 Aug 2019 14:48:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Parav Pandit <parav@mellanox.com>
Cc:     kvm@vger.kernel.org, kwankhede@nvidia.com,
        linux-kernel@vger.kernel.org, cohuck@redhat.com, cjia@nvidia.com
Subject: Re: [PATCH v2 1/2] vfio-mdev/mtty: Simplify interrupt generation
Message-ID: <20190823144843.1d778c6b@x1.home>
In-Reply-To: <20190808141255.45236-2-parav@mellanox.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>
        <20190808141255.45236-2-parav@mellanox.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 23 Aug 2019 20:48:44 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  8 Aug 2019 09:12:54 -0500
Parav Pandit <parav@mellanox.com> wrote:

> While generating interrupt, mdev_state is already available for which
> interrupt is generated.
> Instead of doing indirect way from state->device->uuid-> to searching
> state linearly in linked list on every interrupt generation,
> directly use the available state.
> 
> Hence, simplify the code to use mdev_state and remove unused helper
> function with that.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  samples/vfio-mdev/mtty.c | 39 ++++++++-------------------------------
>  1 file changed, 8 insertions(+), 31 deletions(-)

Applied this commit to vfio next branch with Christoph's review for
v5.4.  As Connie has another use case for the mdev_uuid() API in
flight, I'm not applying patch 2/.  Thanks,

Alex

> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 92e770a06ea2..ce84a300a4da 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -152,20 +152,9 @@ static const struct file_operations vd_fops = {
>  
>  /* function prototypes */
>  
> -static int mtty_trigger_interrupt(const guid_t *uuid);
> +static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
>  
>  /* Helper functions */
> -static struct mdev_state *find_mdev_state_by_uuid(const guid_t *uuid)
> -{
> -	struct mdev_state *mds;
> -
> -	list_for_each_entry(mds, &mdev_devices_list, next) {
> -		if (guid_equal(mdev_uuid(mds->mdev), uuid))
> -			return mds;
> -	}
> -
> -	return NULL;
> -}
>  
>  static void dump_buffer(u8 *buf, uint32_t count)
>  {
> @@ -337,8 +326,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
>  				pr_err("Serial port %d: Fifo level trigger\n",
>  					index);
>  #endif
> -				mtty_trigger_interrupt(
> -						mdev_uuid(mdev_state->mdev));
> +				mtty_trigger_interrupt(mdev_state);
>  			}
>  		} else {
>  #if defined(DEBUG_INTR)
> @@ -352,8 +340,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
>  			 */
>  			if (mdev_state->s[index].uart_reg[UART_IER] &
>  								UART_IER_RLSI)
> -				mtty_trigger_interrupt(
> -						mdev_uuid(mdev_state->mdev));
> +				mtty_trigger_interrupt(mdev_state);
>  		}
>  		mutex_unlock(&mdev_state->rxtx_lock);
>  		break;
> @@ -372,8 +359,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
>  				pr_err("Serial port %d: IER_THRI write\n",
>  					index);
>  #endif
> -				mtty_trigger_interrupt(
> -						mdev_uuid(mdev_state->mdev));
> +				mtty_trigger_interrupt(mdev_state);
>  			}
>  
>  			mutex_unlock(&mdev_state->rxtx_lock);
> @@ -444,7 +430,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
>  #if defined(DEBUG_INTR)
>  			pr_err("Serial port %d: MCR_OUT2 write\n", index);
>  #endif
> -			mtty_trigger_interrupt(mdev_uuid(mdev_state->mdev));
> +			mtty_trigger_interrupt(mdev_state);
>  		}
>  
>  		if ((mdev_state->s[index].uart_reg[UART_IER] & UART_IER_MSI) &&
> @@ -452,7 +438,7 @@ static void handle_bar_write(unsigned int index, struct mdev_state *mdev_state,
>  #if defined(DEBUG_INTR)
>  			pr_err("Serial port %d: MCR RTS/DTR write\n", index);
>  #endif
> -			mtty_trigger_interrupt(mdev_uuid(mdev_state->mdev));
> +			mtty_trigger_interrupt(mdev_state);
>  		}
>  		break;
>  
> @@ -503,8 +489,7 @@ static void handle_bar_read(unsigned int index, struct mdev_state *mdev_state,
>  #endif
>  			if (mdev_state->s[index].uart_reg[UART_IER] &
>  							 UART_IER_THRI)
> -				mtty_trigger_interrupt(
> -					mdev_uuid(mdev_state->mdev));
> +				mtty_trigger_interrupt(mdev_state);
>  		}
>  		mutex_unlock(&mdev_state->rxtx_lock);
>  
> @@ -1028,17 +1013,9 @@ static int mtty_set_irqs(struct mdev_device *mdev, uint32_t flags,
>  	return ret;
>  }
>  
> -static int mtty_trigger_interrupt(const guid_t *uuid)
> +static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
>  {
>  	int ret = -1;
> -	struct mdev_state *mdev_state;
> -
> -	mdev_state = find_mdev_state_by_uuid(uuid);
> -
> -	if (!mdev_state) {
> -		pr_info("%s: mdev not found\n", __func__);
> -		return -EINVAL;
> -	}
>  
>  	if ((mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX) &&
>  	    (!mdev_state->msi_evtfd))

